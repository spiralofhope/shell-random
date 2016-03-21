# Make and change into a directory:
mcd() { \mkdir "$1" && \cd "$1" ; }



# This used to have  --exclude-type supermount
#alias  df='\df  --human-readable'
_df_sorted(){
  _df() {
    \df  --human-readable  --exclude-type tmpfs  --exclude-type devtmpfs
  }
  # The text at the top
  _df |\
    \head --lines=1
  # The actual list of stuff
  _df |\
    \tail --lines=+2  |\
    \sort --key=${1}
}
alias  df='_df_sorted 5'    # sorted by mountpoint
alias  df='_df_sorted 1'    # sorted by filesystem
