#!/usr/bin/env  sh
# A nicer `df`



#  This used to have  --exclude-type supermount
#alias  df='\df  --human-readable'
_df_sorted(){
  _df() {
    \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
  }
  # The text at the top
  _df |\
    \head --lines='1'
  # The actual list of stuff
  _df |\
    \tail --lines='+2'  |\
    \sort --key=${1}
}
