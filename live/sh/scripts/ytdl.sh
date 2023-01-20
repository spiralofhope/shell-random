#!/usr/bin/env  sh



# https://github.com/yt-dlp/yt-dlp
# https://github.com/yt-dlp/yt-dlp#output-template-examples

# Note that --write-info-json might still contain personal information if special settings are used.



:<<'}'
{
FIXME - The comments need a date.  Therefore give this two passes.



SponsorBlock Options are interesting.
https://sponsor.ajay.app/

  --config-locations PATH

  --batch-file FILE

  --output '%(uploader)s/%(upload_date)s - %(title)s/v.%(ext)s'
  --split-chapters
    --force-keyframes-at-cuts
}



update(){
yt-dlp_linux  --update
}


get_comments() {
yt-dlp_linux  \
  --skip-download  \
  --write-comments  \
  --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/comments--'"$( \date  --utc  +%Y-%m-%d_%H։%M )"'.%(ext)s'  \
$*
}



get_subtitles() {
yt-dlp_linux  \
  --no-abort-on-error  \
  --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/subs/v.%(ext)s'  \
  --skip-download  \
  --write-subs  \
    --all-subs  \
    --convert-subs srt  \
    --write-auto-subs  \
$*
}



get_video_etc(){
yt-dlp_linux  \
  --concurrent-fragments  3  \
    --no-keep-fragments  \
  --continue  \
  --embed-chapters  \
  --embed-metadata  \
    --xattrs  \
  --no-abort-on-error  \
  --no-write-subs  \
    --all-subs  \
    --embed-subs  \
    --write-auto-subs  \
  --output '%(uploader)s/%(upload_date>%Y)s-%(upload_date>%m)s-%(upload_date>%d)s - %(title)s/v.%(ext)s'  \
  --rm-cache-dir  \
  --windows-filenames  \
  --write-description  \
  --write-info-json  \
    --clean-info-json  \
    --embed-info-json  \
  --write-link  \
    --write-desktop-link  \
    --write-url-link  \
    --write-webloc-link  \
  --write-thumbnail  \
    --embed-thumbnail  \
$*
}



#update
get_comments   $*  && \
get_subtitles  $*  && \
get_video_etc  $*


#get_subtitles  $*  && \


:<<'}'
{
#  --limit-rate 50K  \


For some reason this writes the json file one directory up:
  --trim-filenames 50  \
}
