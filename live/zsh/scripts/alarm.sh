#!/usr/bin/env  sh



\echo  'Alarm started.'

# TODO:  Is there a way to occasionaly display the remaining time?
\sleep $*


# Visual notification.
# TODO - I could just open a terminal, use Xdialog, zenity or some other such thing.
\echo  'alarm' | \leafpad &


# Audio
# FIXME - There is popping between notes.
# TODO? - A mono chiptune.
#   As I'm not a musician and simple searches have not come up with the "source" frequency/duration for each note for such music, I cannot produce anything easily.
# TODO? - A stereo chiptune.
#   It feels possible to essentially create two "threads", and control left and right speakers separately.
#   Hell, more speakers are probably also possible.
# TODO? - Experiment with multiple mono threads.  Can multiple instances of speaker-test exist and play overlapping notes simultaneously, simulating multiple channels?
_alarm() {
  ( \speaker-test  --frequency $1  --test sine )&
  pid=$!
  \sleep  0.${2}s
  \kill  -9 $pid
}



_alarm  400  200
_alarm  450  300
_alarm  400  200
_alarm  450  400
_alarm  400  400
