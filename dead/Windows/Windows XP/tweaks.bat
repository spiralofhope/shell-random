: Disable Last Access timestamp
fsutil behavior set disablelastaccess 1

: Disable 8.3 filenames
: Note that this will screw up 16bit (Windows 3.1) programs.
fsutil behavior set disable8dot3 1 
