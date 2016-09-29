#!/bin/sh

if [ -n $1 ]
then
  DECMAC="."`../mac2dec $@`
fi

snmpwalk -v2c -c public -On 192.168.1.9 1.3.6.1.4.1.14179.2.1.11.1.5${DECMAC} \
| sed -e 's/\([^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\)\(\.[^. ]*\.[^. ]* =\)/ \1 \2/' \
| sed -e 's/\([^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\.[^. ]*\)\. / \1 /' \
| while read F1 MAC1 MAC2 REST
do
  echo $F1 $MAC1 "("`../dec2hex $MAC1`")" $MAC2 "("`../dec2hex $MAC2`")" $REST
  #echo $F1 `../dec2hex $MAC1` `../dec2hex $MAC2` $REST
done \
| sed -f waptable.sed \
| sort -r -n -k8,8
