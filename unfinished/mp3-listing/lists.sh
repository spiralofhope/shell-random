#!/usr/bin/env  sh



# IDEA: Convert this into a commandline thingy.  I could have it accept
# a name and then just build a subdirectory with those files..

# I could clean things up by having a variable to put the group name in, and
# just run a subroutine with that variable, changing that var as I go..



list_dir='/home/user/media/_built/lists'
music_dir='/home/user/media/music'
music_dirs_list="$music_dir/sorted $music_dir/unsorted-tested"



go() {
  ## I could expand this like:
  ## list="../../tested/ ../../untested/"
  \echo  "* Building lists/ -- \"$1\" from \"$2\""

# TODO: Intelligently delete.. be really safe about this!
#   \rm  --force  --recursive  ./"$1"/
#   \mkdir  ./"$1"

  # FIXME: Something is wrong here..  =/
  \find  -L  $music_dirs_list  -name \""$2\""  -exec \
    \ln -s --target-directory="$list_dir"/"$1"/ $3{} \;
}



\echo  '* Building lists/'
# rm  --force  --recursive  $lists_dir
\mkdir  --parents  $lists_dir
\cd  $lists_dir

\echo  'Duplicates may be revealed during this list-building.'

# lists.go.sh
# $1 = Directory name
# $2 = Search pattern
# $3 = (optional) set to ../ for sub-directories
#
# better specify *.mp3, otherwise it'll catch directories too.  =)
go  'In This Moment' 'In This Moment *.mp3'
go  'Colin James'		'Colin James *.mp3'
# go  'Christina Aguilera'		'Christina Aguilera *.mp3'
go  'Deathstars'		'Deathstars *.mp3'
go  'Metric'		'Metric *.mp3'
# go  'Billy Talent'		'Billy Talent *.mp3'
go  'Disturbed'			'Disturbed *.mp3'
go  'Sean Paul'			'*Sean Paul *.mp3'
go  'Sinergy'			'Sinergy *.mp3'
go  'Def Leppard'		'Def Leppard *.mp3'
# go  'Pink'			'Pink *.mp3'
go  'Red Hot Chili Peppers'	'Red Hot Chili Peppers *.mp3'
# go  'Children Of Bodom'		'Children Of Bodom *.mp3'
# go  'Billy Talent'		'Billy Talent *.mp3'
# go  'Green Day'			'Green Day *.mp3'
go  'ACDC'			'ACDC *.mp3'
go  'Doro'			'Doro *.mp3'
go  'Shakira'			'Shakira *.mp3'
go  'No Doubt'			'No Doubt *.mp3'
go  'No Doubt/Gwen Stefani'	'*Gwen Stefani *.mp3'		../
go  'Annette Ducharme'		'Annette Ducharme *.mp3'
# go  'Sirenia'			'Sirenia *.mp3'
go  'Papa Roach'		'Papa Roach *.mp3'
# go  'Steve Vai'			'Steve Vai *.mp3'
# go  'Joe Satriani'		'Joe Satriani *.mp3'
# go  'Yngwie Malmsteen'		'Yngwie Malmsteen *.mp3'
go  'The Gathering'		'The Gathering *.mp3'
go  'Lacuna Coil'		'Lacuna Coil *.mp3'
go  'Rammstein'			'Rammstein *.mp3'
go  'Sevendust'			'Sevendust *.mp3'
go  'Taproot'			'Taproot *.mp3'
# go  'Alien Ant Farm'		'Alien Ant Farm *.mp3'
go  'Linkin Park'		'Linkin Park *.mp3'
go  'System Of A Down'		'System Of A Down *.mp3'
go  'Theatre Of Tragedy'	'Theatre Of Tragedy *.mp3'
# go  'George Carlin'		'George Carlin *.mp3'
go  'National Velvet'		'National Velvet *.mp3'
go  'Dido'			'Dido *.mp3'
go  'Evanescence'		'Evanescence *.mp3'
# go  'Covenant'			'Covenant *.mp3'
go  'Big Sugar'			'Big Sugar *.mp3'
go  'Within Temptation'		'Within Temptation *.mp3'
go  'Nickelback'		'Nickelback *.mp3'
go  'Tea Party'			'Tea Party *.mp3'

\mkdir  'Brave Words & Bloody Knuckles'
go  'Brave Words & Bloody Knuckles/Knuckletracks'	'*Knuckletracks*.mp3'	../
go  'Brave Words & Bloody Knuckles/Blood Tracks'	'*Blood Tracks*.mp3'	../

:<<XMAS

# Proof of concept -- build a list of holiday-related songs:
# Would be nice to also organize things if they're comedy..
mkdir "_Xmas"
go "_Xmas/1"			"*Christmas*"			../
go "_Xmas/2"			"*Snow*"			../
go "_Xmas/3"			"*Santa*"			../
go "_Xmas/4"			"*Reindeer*"			../
# Link all files into the one root directory:
# ~DO: Intelligently move the links and re-link somehow?  Ugh!
cd ./_Xmas/
find -L ./1/ ./2/ ./3/ ./4/ -name "*" -exec ln -s --target-directory=./ {} \;
# remove the links that point to irrelevant files.
\rm  --verbose  ./Sevendust*Xmas\ day*
\rm  --verbose  ./Arch\ Enemy*Snow\ bound*
\rm  --verbose  ./Clannad*A\ dream\ in\ the\ night*
\rm  --verbose  ./Enigma*Snow\ of\ the\ sahara*
\rm  --verbose  ./Luca\ Turilli*Lord\ of\ the\ winter\ snow*
\rm  --verbose  ./Snow\ *			# The artist "Snow"
\rm  --verbose  ./Santana*		# The artist "Santana"  You're not santa!
cd ../

XMAS


# Build one with songs that are about a "name" (ABBA - Maria, etc)
# Maybe for "money" (Extreme - Money (In God We Trust))
# Build one for "metal" (maybe a metal without glam)
# Maybe an 80's
# Maybe 'grunge'
# Maybe other eras and styles
# Maybe women of metal / velvet darkness / gothic / operatic / harmonic etc.
# Build some custom albums via this method.
# Gothic Metal
# Gothic Rock

# how the hell would any of that be possible?  I'd have to tag files somehow..
# I guess that's where ID3s come in?  Or my database project.  Sigh.


# Ugh, what a messy way to do this..
\mkdir  '70s'
go  '70s/1'			'The Jackson 5 *'		../
go  '70s/2'			'Sly & The Family Stone *'	../
