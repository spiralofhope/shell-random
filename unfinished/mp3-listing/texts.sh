\echo  '* Building the texts'
\cd  ../

\echo  '* Building the texts -- tested.txt'
\tree  -dFlnq             ../tested/			> ./tested.txt
\tree  -Flnsq --dirsfirst ../tested/			>>./tested.txt

\echo  '* Building the texts -- favourites.txt'
# Wow, there are no long-forms for tree's switches
\tree  -dFlnq               ../tested/ | \grep  --ignore-case  '~.mp3'	> ./favourites.txt
\tree  -Flnsq  --dirsfirst  ../tested/ | \grep  --ignore-case  '~.mp3'	>>./favourites.txt
# I could also do:
# \more < ./tested.txt | \grep  --ignore-case  '~.mp3' > ./favourites.txt
# I decided against this, because it should be quite fast to re-do the tree in this way.  I hope.
# No, it's not appropriate to just look at ./favourites/ since that's not "the source".

\echo  '* Building the texts -- untested.txt'
\tree  -dFlnq               ../untested/	> ./untested.txt
\tree  -Flnsq  --dirsfirst  ../untested/	>>./untested.txt

\echo  '* Building the texts -- dislike.txt'
\tree  -dFlnq               ../Dislike/ 	> ./dislike.txt
\tree  -Flnsq  --dirsfirst  ../Dislike/ 	>>./dislike.txt

\echo  '* Building the texts -- lists.txt'
# The lists built with lists.sh
\tree  -dFlnq  ./lists/						> ./lists.txt
\ls  --dereference  --no-group  --recursive  --size  ./lists/ | \sort  >>./lists.txt
# no sorted list need be made, since it's only one directory and is already sorted.




# ------------ NOTES

# FYI, "tree" can handle multiple directories, such as:
# tree -dFlnq ../tested/ ../untested/ ../Dislike/	> ./most.txt




#tree -dFlnq ../								> ../all.txt
#tree -Flnsq --dirsfirst ../							>>../all.txt

# can't not show directories.  Bullshit.  I'd have to somehow nuke blank lines and lines with "/" in them.
###	ls -R ../ | sort								> ../all.sorted.txt
# can't do this because control characters still bleed through, even though a commandline ls|less doesn't show any
#find ../ -exec ls --block-size=1 {} \;					> ../all.sorted.txt
#more < ../all.sorted.txt > ../all.sorted.txt

###	ls -GLRs --block-size=1 ../archive/ ../saved/ ../untested/ | sort	> ../most.sorted.txt
