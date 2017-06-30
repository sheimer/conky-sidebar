#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

export LC_NUMERIC="en_US.UTF-8"

case $1 in
  weather)
    curl -s "api.openweathermap.org/data/2.5/weather?q=${owmcity}&units=metric&appid=${owmtoken}&lang=${owmlang}" -o "${conkydir}/cache/weather.json"
    ;;
  forecast)
    curl -s "api.openweathermap.org/data/2.5/forecast/daily?q=${owmcity}&units=metric&appid=${owmtoken}&lang=${owmlang}" -o "${conkydir}/cache/forecast.json"
    ;;
  *)
    echo $"Usage: $0 {weather|forecast}"
esac
exit 0
