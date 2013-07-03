# A little awk script which tells you how many shell accounts you have
# and also what shells are used for the accounts.
# Usage: awk -f stat.awk /etc/passwd

BEGIN{
FS=":"
#seperator is set to :
}
{
#$7, is 7 field in passwd file
  stat_array[$7]=stat_array[$7]+1;
}
END{
print "Login-Shells Count" ;
for (i in stat_array) print i, stat_array[i]
#Displays statistics
}       
#end here
