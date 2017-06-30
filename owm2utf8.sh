#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

echo -ne "\u`xmllint --xpath '//string[@name="'$1'"]/text()' "$conkydir"/weathericons.xml | sed s/\&#x//g | sed s/\;//g`"
