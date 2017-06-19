#!/bin/bash
echo -ne "\u`xmllint --xpath '//string[@name="'$1'"]/text()' ~/conky-sidebar/weathericons.xml | sed s/\&#x//g | sed s/\;//g`"
