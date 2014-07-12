# This won't work because the collection is too large!
\echo  '* Building flat/'
\echo  '* Building flat/ -- NOTE: Any file that is mentioned here is a duplicate filename.'

\cd  ../
# ~DO:  if exist
# This will fail <----------------------
# A ruby solution would work!
\rm  --force  --recursive  ./flat/
\mkdir  ./flat/

\echo  '* Building flat/ -- tested'
\find  ../music  -name \*.mp3  -exec \
  \ln  --symbolic ../{} --target-directory=./flat/ \;

# echo "* Building flat/ -- untested"
# find ../untested -name \*.mp3 -exec ln -s ../{} --target-directory=./flat/ \;
