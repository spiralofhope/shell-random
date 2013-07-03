# to use, simply run with $1 being the track number.  It will rip it and encode it.

cd /

echo "------------------------------------"
echo "ripping track #"$1
/cdparanoia-III-alpha9.8/cdparanoia -B -sv $1

echo "------------------------------------"
echo "encoding with --r3mix \(perfect cd audio quality settings\)"
/lame-20011214/lame --nspsytune --vbr-mtrh -V1 -mj -h -b96 --lowpass 19.5 --athtype 3 --ns-sfb21 2 -Z --scale 0.98 -X0 track$1.cdda.wav track$1.mp3


echo "------------------------------------"
rm -i track$1.cdda.wav
