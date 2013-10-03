#/bin/sh


:<<NOTES
- given a directory, and a text file
- get information from the directory and put it in the text file.

Things to get:
- Title  --  e.g. The 13th Warrior
- Year  --  e.g. 1999
- Spoken Language(s)  --  e.g. .ger for German  --  idea: make a mouseover link to give the full language name
- Media notes  --  e.g. b&w (black and white), sepia (monochrome - sepia-tone), short film, "see also", "remake of", etc.
- Movie notes  --  Whatever random thoughts I've had.  Put them in a text file which can be read in and placed with this movie, hidden in a spoiler tag.
- Wikipedia link  --  e.g. The_13th_Warrior becomes https://en.wikipedia.org/wiki/The_13th_Warrior  --  if no link given, use the title (and note that this was a guess?).
- IMDB link  --  e.g. tt0120657 becomes http://www.imdb.com/title/tt0120657/  --  if no link given, reference an IMDB search (and note this fact)

I think it's best to have this information available within a subdirectory, as a set of files.  Put the info in the filenames themselves.

usage:

for i in *; do  movie-list-builder.sh $i /tmp/filename.html  ; done

TODO
- make a generic link concept
- how do I process series' ?

NOTES