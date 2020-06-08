#!/usr/bin/perl -w
#
# kmx2mbox
# version 1.5 12/09/2002
#
# by: Daniel Mota Leite  (higuita@Gmx.net) - Portugal
# tmp website: http://caravela.homelinux.net/~higuita/kmx2mbox
# (dynamic DNS site, maybe offline sometimes)
#
# Changelog:
# version 1.5 12/09/2002: added the news beta .mwx mailbox format
#                         this format is very simple, almost mbox
#                         add too a check for bogus "from" email 
#                         used by some broke emails (read: spam)
# version 1.2 29/06/2002: tweaked a little to make better mbox format...
#                          this should allow a direct use of the mbox in
#                          eudora
# version 1.1  1/12/2001: add support for ancient MW mailboxes but already 
#                          converted to kmx mailboxes, i can find and fix the
#                          from and subject, i have no idea where MW goes get
#                          the date from this headerless emails, it will use
#                          the last date found or 1/1/1998 if none found
# version 1.0c 5/11/2001: initial release
#
#----------------------------------------------------------------------------
#This program is protected by the GNU General Public License.  Please see
#http://www.gnu.org for information regarding the GNU General Public License.
#----------------------------------------------------------------------------
#
# this little perl script translates the uncompressed kmx mailboxes from 
# the great email client for window$, Kaufman Mail Warrior 3.61, to the 
# standard unix mbox.
# Most emails clients can read/import this files.
#
# i made this because the MW was the only thing that force me to boot
# to window$ to read my new email and find old emails in my big mailboxes
# (fgrep and fetchmail/others could do this was not "easy" and practical)
# MW cant work in wine and don't have any export email option and i didn't
# want to have some emails in windows and others in Linux
# with this i can get the email i get from window$ to Linux and use
# the Linux as my main OS and window$ just for some games
# Kaufman already said that he will make a Linux version of MW too, but 
# until it show up this is a easy way to share the MW emails with Linux
#
# kmx2mbox (name) read the kmx file with that name and writes one mailbox
# file to the same dir with the name name.mbox without the .kmx
# is up to the user to move and rename the mbox files to use then
# ex: kmx2mbox Inbox.kmx  will save the file to Inbox.mbox to the same dir
#
#
# To use just make sure the the MW mailbox are uncompressed
# (ie: you didn't ever used the compact command in MW)
# if they are compressed, create a new mailbox and copy the emails
# to that new mailbox and this time don't compact it.   8)
# Then in Linux, copy the kmx files to a dir, place the kmx2mbox in that dir
# or put it on the path, go to that kmx dir  and run:
#
#   for file in *.kmx; do kmx2mbox "$file"; done
#
# this will convert all the kmx files on the directory
#
# this is what the main idea from the script:
# -search  ^(?^@^@^@) -1 random character + 3 null characters at the start 
#  of the line (i call this the start message code)
# -ignore until the ++first++ *(!MW36_xMailBoundary)* is found (must ignore 
#  this line too...this is the start email code )
# -Save the email until the next ^(?^@^@^@) is found
# -start over again
# of course there is small problems (codes), but i think i manage then all
#
# Known Bugs:
# -REALLY wierd spam/virus emails may confuse the script and most probably
#  will finish inside other, more normal email... not a big deal, at least
#  for me. in my many emails, i only found ONE wierd email like this
# -it doesn't check to see if the name.mbox already exists
# -cant rebuild the attach files (hey, search the attach folder, you have 
#  the names at the end of each email
# -cant work with compressed kmx
# -i think this work only for MW 3.6x mailboxes (not sure)
# -don't know if i got all the possible "start message" codes, if you get
#  any email inside others, check this to see what i have missed...
#  for now it check for ?^@, ?^A to ?^E and ^^A 
#   (maybe it's fixed, found a safer/better way)
#
# i wrote many comments, this script should be easy to understand (i hope)
#
#	Good luck and enjoy
#
$nome=shift;
unless ($nome) {$nome=""};
$mbox=$nome;
$mbox_nova=$nome;
$mbox=~ s/.kmx/.mbox/i;
$mbox_nova=~ s/.mwx/.mbox/i;
$ok=0;
$n=0;
$i=0;
@email="";
$from="";
$date="";
$subject="";
$to="";
$from_ok=0;
$date_ok=0;
$date="Sun, 1 Jan 1998 00:00:00 -0000";
$i_old=0;
$new_format=0;

# protection against screw up files with no kmx extension
# without this the script will overwrite all files without .kmx
unless ( ( $nome=~ /.kmx/i) || ( $nome=~ /.mwx/i) ) {
	print " $nome No kmx/mwx extension... Aborting\n";
	exit;
}

print "Reading $nome\n\n";

# read the mailbox $nome
open(DATA,   "<  $nome") || die("ERROR - can't open datafile: $!");
	@msg=<DATA>;
close(DATA);

# save the new mailbox with the correct translated name
if ($nome=~ /.mwx/i) {
	$new_format=1;
open(DATA , ">$mbox_nova ") || die("ERROR - cant open datafile: $!"); 
}
else {
	# Open the file .mbox for write
open(DATA , ">$mbox ") || die("ERROR - cant open datafile: $!");
}

foreach $linha(@msg) {
	$i_old++;   #i_old is used to find the from and date from old, imported kmx 

# If found the end of the kmx mailbox, save and exit
	if ($linha =~ /^QIX/){
		&save;
		&exit;
	}
# new MW beta mailbox format converter
	elsif ( ( $new_format==1 ) && (  substr($linha,0,19) ne "???\@MW_SEPARATOR???" ) ){
		$linha =~ s/\r//g;
		&check_headers;
		$email[$i]=$linha;
		$i++;
	}
	elsif ( ( $new_format==1 ) && (  substr($linha,0,19) eq "???\@MW_SEPARATOR???" ) ){
		&save;
		$n++;
		print "$n -> $from $date\n";
		$i=0;
                $from_ok=0;
                $from="";
                @email="";
		$ok=1;
                $date_ok=0;
                $i_old=0;
	}
	elsif ( $i_old==4 ){
		$from_old=$linha;
	}
	elsif ( $i_old==5 ){
		$to=$linha;
	}

# search for the start of the kmx (QDB) and for the start message codes
# we will ignore the next lines (this one included) until the email start code below
# when the start message code is found we save the previous email in mailbox format
# and reset thing for the next one
	elsif ( ($linha =~ /^QDB/ || substr($linha,1,3) eq "\x00\x00\x00" || substr($linha,1,3) eq "\x01\x00\x00" || substr($linha,1,3) eq "\x02\x00\x00" || substr($linha,1,3) eq "\x03\x00\x00" || substr($linha,1,3) eq "\x04\x00\x00" || substr($linha,1,3) eq "\x05\x00\x00" || substr($linha,0,3) eq "\x01\x00\x00") &&  $ok ==0 ) {
		$ok=1;
		$date_ok=0;
		$i_old=0;
# escape for the first run
		if ( $i >0 ) {
			&save;
			$subject=substr ($linha,4);
		}
		else{
			$subject=substr ($linha,12);
		}
		$i=0;
		$from_ok=0;
		$from="";
		@email="";
	}
# if start of the message was already found (ok=1), start searching for the start 
# of email codes, then reset the ok code to allow the saving and count the emails found
# there is another "start email code", the �@^@^@^@^@ from 7 to 13, but have 
# more variations
	elsif (  $ok==1 ) {
###
#found a better way 8)
#		if ( $linha =~ /\xe2\x40\x00\x00\x00\x00/  ||  $linha =~  /\xe1\x40\x00\x00\x00\x00/ || $linha =~ /\xe0\x40\x00\x00\x00\x00/ ) {
###
		if ( $linha =~ /!MW36_xMailBoundary/ ) {
			$ok=0;
			$n++;
# if you want a the old view, swap the comment of this lines below, else
# this way helps debug as it have a list of the subject of each email found 
# you may comment both for a little faster conversion and with less junk on screen
#			print "$n ";
			print "$n -> $subject";

		}
	}

# Clean the line of the email code if it have any newline code
# any email shouldn't have null character (as far as i know)
# also, the MW boundary text, so it doesn't show up in the email

	else{ 
		unless( $linha =~ /\x00/ || $linha =~ /^!MW36_xMailBoundary/ ){

# we strip the carrier return from DOS !!! is this needed?!?
# if you plan to use this mbox in window$, you might get better
# results if you don't strip this code
# for me this works fine with linux email clients

			$linha =~ s/\r//g;

			&check_headers;
# save the email
			$email[$i]=$linha;
			$i++;

		}
# remove the next attach codes and inserts a newline so the mbox knows where 
# the header finish
		elsif ( $linha=~/^!MW36_xMailBoundary/){
			$email[$i]="\n";
			$i++;
		}
	}
}

# shouldn't be needed, but might help in broken kmx, without the QDB end
# like those TMP created when the MW crash, this could be a way to recover
# the lost emails  
# i didn't test it yet, any info is welcome

&save;
&exit;

#######################
###### Modules ########
#######################

sub save{
# the mbox format need a "\nFrom name date" at start of each email 
# the "converted" header is just to fix some incomplete headers
# i had only one very old kmx mailbox that had this problem
# this helps this emails and doesnt do anything for the others 
# ignore if there is no email (ie: the last field in the new MW format) 
	unless  ( $email[0] eq "" ){
		$head="";
		if ( $from_ok==0 && $email[0] ne "" ) {
	                $from= $from_old;
			$from=~ s/\n//;
			$from=~ s/\r//;
			$subject=~ s/\n//;
			$to=~ s/\n//;

#fake missing header for the old imported kmx
			$head= "From: $from\nDate: $date\nSubject: $subject\nX-Mailer: Mail Warrior 2\nTo: $to\n";
			$head=~ s/\r/ /g;
		}
		print DATA "\nFrom $from $date\nConverted: kmx2mbox\n";
		print DATA $head;
		print DATA @email;
	}
}



#closes files, display sumary, have a nice day... 8)
sub exit{
	close(DATA);
	print "\n\nConverted $n emails to mbox $mbox\n\n";
	exit;
}



# check the From, Date and Content-Type: multipart (there is no attach, 
# this can screw some email clients)
sub check_headers{
	if ($linha =~ /^From: /i && $from_ok==0) {
		$from= $linha;
		unless ( $from =~ /\@/ ) { $from=" bogus\@email.none"; }
		$from=~ s/[<>]//ig;
		$from=~ s/^From:.*\s+([^\s]+@[^\s]+\.[\w\d]+)(.*)?/$1/i;
		$from=~ s/\n//;
		$from_ok=1;
	}
	elsif ($linha =~ /^Date: /i && $date_ok==0) {
		$date= $linha;
		$date=~ s/^Date: //i;
		$date=~ s/\n//;
		$date=~ s/,//;
		$date_ok=1;
	}
#hide multipart
	elsif ( $linha=~ /^Content-Type: multipart/i) {
		$linha=~ s/^Content-Type: multipart/encode-/i;
	}
}
