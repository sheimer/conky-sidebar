#!/bin/bash

cd "$(dirname "$0")"

if [ ! -f ./conky-sidebar.conf ]; then
  echo "please mv conky-sidebar.conf.sample to conky-sidebar.conf and configure it"
  exit 1
else
  source ./conky-sidebar.conf
fi

export LC_NUMERIC="en_US.UTF-8"

file="$conkydir"/cache/weather.json

case $1 in
  icon_now)
    dt=$(jq -r '.dt' $file)
    sunrise=$(jq -r '.sys.sunrise' $file)
    sunset=$(jq -r '.sys.sunset' $file)
    if [ "$dt" -gt "$sunrise" ] && [ "$dt" -lt "$sunset" ]; then
      daynight='day_'
    else
      daynight='night_'
    fi
    "$conkydir"/owm2utf8.sh 'wi_owm_'$daynight$(jq -r '.weather[0].id' $file)
    ;;
  temp_now)
    printf "%.0f"  $(jq -r '.main.temp' $file)
    ;;
  day)
    echo -n $(date -d +${2}day +%^a)
    ;;
  icon)
    file="$conkydir"/cache/forecast.json
    "$conkydir"/owm2utf8.sh 'wi_owm_'$(jq -r '.list['$2'].weather[0].id' $file)
    ;;
  temp_min)
    file="$conkydir"/cache/forecast.json
    printf "%.0f" $(jq -r '.list['$2'].temp.min' $file)
    ;;
  temp_max)
    file="$conkydir"/cache/forecast.json
    printf "%.0f" $(jq -r '.list['$2'].temp.max' $file)
    ;;
  pressure)
    echo -n $(jq -r '.main.pressure' $file)
    ;;
  humidity)
    echo -n $(jq -r '.main.humidity' $file)
    ;;
  wind_speed)
    speed=$(echo $(jq -r '.wind.speed' $file)*3.6 | bc)
    printf "%.0f" $speed
    ;;
  wind_degree)
    echo -n $(jq -r '.wind.deg' $file)
    ;;
  wind_degree_icon)
    degree=$(jq -r '.wind.deg' $file)
    if [ "$degree" == null ]; then
      "$conkydir"/owm2utf8.sh 'wi_na'
    elif [ "$degree" -gt 337 ] || [ "$degree" -lt 23 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_up'
    elif [ "$degree" -lt 68 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_up_right'
    elif [ "$degree" -lt 113 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_right'
    elif [ "$degree" -lt 158 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_down_right'
    elif [ "$degree" -lt 203 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_down'
    elif [ "$degree" -lt 248 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_down_left'
    elif [ "$degree" -lt 293 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_left'
    elif [ "$degree" -lt 338 ]; then
      "$conkydir"/owm2utf8.sh 'wi_direction_up_left'
    fi
    ;;
  description)
    echo -n "$(jq -r '.weather[0].description' $file)" #"|$(jq -r '.weather[0].id' $file)"
    ;;
  *)
    echo $"Usage: $0 {icon_now|temp_now|day {0|1|2|...}|icon {0|1|2|...}|temp_min {0|1|2|...}|temp_max {0|1|2|...}|pressure|humidity|wind_speed|wind_degree|wind_degree_icon|description}"
esac
