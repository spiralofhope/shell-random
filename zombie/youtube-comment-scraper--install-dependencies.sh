#!/usr/bin/env  sh
# Download and install the dependencies for youtube-comment-scraper:
#   https://github.com/philbot9/youtube-comment-scraper/
# Tested 2019-10-29 on 9.9.0-i386-xfce-CD-1 though the actual youtube-comment-scraper has not been tested.



\sudo  \apt-get  -y  install  unzip
\mkdir  static/libs



#:<<'}'   #  jQuery
         # https://jquery.com/
{
  \wget  --continue  --output-document='./youtube-comment-scraper/static/libs/jquery.min.js'  'https://code.jquery.com/jquery-3.4.1.min.js'
}



#:<<'}'   #  Font Awesome
         # https://fontawesome.com/
{
  target='./youtube-comment-scraper/static/font-awesome/'
  filename='fontawesome-free-5.11.2-web'
  \wget  --continue  'https://use.fontawesome.com/releases/v5.11.2/fontawesome-free-5.11.2-web.zip'
  \unzip  "$filename".zip
  \mkdir  "$target"
  \mv  "./$filename/*"  "$target"
  \rmdir  "$filename"
  \rm  --force  "$filename"
}



#:<<'}'   #  Bootflat
         # https://bootflat.github.io/
{
  target='./youtube-comment-scraper/static/bootflat/'
  unzipped_directory='bootflat.github.io-master'
  filename="bootflat--$( \date  +%Y-%m-%d ).zip"
  \wget  --continue  --output-document="$filename"  'https://github.com/Bootflat/Bootflat.github.io/archive/master.zip'
  \unzip  "$filename"
  \mkdir  "$target"
  \mv  "./$unzipped_directory"/*   "$target"
  \mv  "./$unzipped_directory"/.*  "$target"
  \rmdir  "./$unzipped_directory/"
  \rm  --force  "$filename"
}



#:<<'}'   #  Papa Parse
         # https://www.papaparse.com/
{
  target='./youtube-comment-scraper/static/libs/papaparse.min.js'
  unzipped_directory='PapaParse-5.0.2'
  filename="papaparse--$( \date  +%Y-%m-%d ).zip"
  \wget  --continue  --output-document="$filename"  'https://github.com/mholt/PapaParse/archive/5.0.2.zip'
  \unzip  "$filename"
  \mv  "./$unzipped_directory/papaparse.min.js"  "$target"
  \rm  --force  --recursive  "./$unzipped_directory/"
  \rm  --force  "$filename"
}



#:<<'}'   #  json.human.js
         #  https://github.com/marianoguerra/json.human.js
{
  target='./youtube-comment-scraper/static/libs/json.human.css'
  \wget  --continue  --output-document="$target"  'https://github.com/marianoguerra/json.human.js/raw/master/css/json.human.css'
  target='./youtube-comment-scraper/static/libs/json.human.js'
  \wget  --continue  --output-document="$target"  'https://github.com/marianoguerra/json.human.js/raw/master/src/json.human.js'
}



#:<<'}'   #  download.js
         #  http://danml.com/download.html
{
  target='./youtube-comment-scraper/static/libs/download.js'
  \wget  --continue  --output-document="$target"  'http://danml.com/js/download.js'
}
