if [ -z $1 ]; then
  echo 'yeah, but what package?'
  exit 0
fi
package_exact_name=`rpm -qa | grep -i "$1"`
rpm -e $package_exact_name