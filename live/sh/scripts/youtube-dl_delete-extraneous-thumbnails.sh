#!/usr/bin/env  sh

# Delete extraneous thumbnails, if any.
# TODO - This is the most stupid and blunt thing to do, and I don't know if it'll delete too much.
#        Is there a way to have YouTube-dl only fetch the highest-quality thumbnail? 
# TODO - If I must, rework this like a human thinks:  Build a list of all images and keep the largest.
# TODO? - convert a remaining .webp to something sane.



if [ -f 'v_4.webp' ]; then
  \rm  --force  v_*.jpg
fi
if [ -f 'v_3.jpg' ]; then
  \rm  --force  'v_0.jpg'
  \rm  --force  'v_1.jpg'
  \rm  --force  'v_2.jpg'
fi
if [ -f 'v_4.jpg' ]; then
  \rm  --force  'v_3.jpg'
fi
if [ -f 'v.webm_4.jpg' ]; then
  \rm  --force  'v.webm_0.jpg'
  \rm  --force  'v.webm_1.jpg'
  \rm  --force  'v.webm_2.jpg'
  \rm  --force  'v.webm_3.jpg'
fi
if [ -f 'v.webm_3.jpg' ]; then
  \rm  --force  'v.webm_0.jpg'
  \rm  --force  'v.webm_1.jpg'
  \rm  --force  'v.webm_2.jpg'
fi
if [ -f 'v.mp4_3.jpg' ]; then
  \rm  --force  'v.mp4_0.jpg'
  \rm  --force  'v.mp4_1.jpg'
  \rm  --force  'v.mp4_2.jpg'
fi
if [ -f 'v.webm_4.webp' ]; then
  \rm  --force  'v.webm_0.jpg'
  \rm  --force  'v.webm_1.jpg'
  \rm  --force  'v.webm_2.jpg'
  \rm  --force  'v.webm_3.jpg'
fi
if [ -f 'v.mp4_4.jpg' ]; then
  \rm  --force  'v.mp4_3.jpg'
  \rm  --force  'v.mp4_2.jpg'
  \rm  --force  'v.mp4_1.jpg'
  \rm  --force  'v.mp4_0.jpg'
fi
if [ -f 'v.mp4_4.webp' ]; then
  \rm  --force  'v.mp4_0.jpg'
  \rm  --force  'v.mp4_1.jpg'
  \rm  --force  'v.mp4_2.jpg'
  \rm  --force  'v.mp4_3.jpg'
fi
