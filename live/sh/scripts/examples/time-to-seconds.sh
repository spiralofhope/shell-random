# See also:
# Parse ps' "etime" output and convert it into seconds
# https://stackoverflow.com/questions/14652445


# https://stackoverflow.com/questions/2181712



local  t='00:02:01.08'
echo $t


to_seconds() {
  local epoch=$( \date --utc  --date @0  +%F )
  \date  --utc  --date "$epoch $1"  +%s.%09N
}

to_seconds  $t
#  =>  121.080000000


\echo "$t" | \awk -F: '{ print ( $1 * 3600 ) + ( $2 * 60 ) + $3 }'
#  =>  121.08

# Decimal hours:
\echo "$t" | \awk -F: '{ print $1 + ( $2 / 60 ) + ( $3 / 3600 ) }'
#  =>  0.0336333





# hh:mm:ss
local t="04:20:40"
# mm:ss
local t="20:40"
# ss
local t="40"
# ss.ms
local t="40.2"
# This would work even if you don't specify hours or minutes: 
\echo "$t" |\
  \sed -E \
  's/(.*):(.+):(.+)/ \
  \1 * 3600 + \2 * 60 + \3 / ; s/(.+):(.+)/ \
  \1 * 60 + \2 / ' |\
  \bc




# You can learn the length of an audio file like so:
#t=$( \avconv  -i "$file"  2>&1 | \grep Duration | \awk '{print $2}' | \tr -d ',' )
