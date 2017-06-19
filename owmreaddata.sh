#!/bin/bash

export LC_NUMERIC="en_US.UTF-8"

FILE=~/conky-sidebar/cache/weather.json

case $1 in
  icon_now)
    DT=$(jq -r '.dt' $FILE)
    SUNRISE=$(jq -r '.sys.sunrise' $FILE)
    SUNSET=$(jq -r '.sys.sunset' $FILE)
    if [ "$DT" -gt "$SUNRISE" ] && [ "$DT" -lt "$SUNSET" ]; then
      DAYNIGHT='day_'
    else
      DAYNIGHT='night_'
    fi
    ~/conky-sidebar/owm2utf8.sh 'wi_owm_'$DAYNIGHT$(jq -r '.weather[0].id' $FILE)
    ;;
  temp_now)
    printf "%.0f"  $(jq -r '.main.temp' $FILE)
    ;;
  day)
    echo -n $(date -d +${2}day +%^a)
    ;;
  icon)
    FILE=~/conky-sidebar/cache/forecast.json
    ~/conky-sidebar/owm2utf8.sh 'wi_owm_'$(jq -r '.list['$2'].weather[0].id' $FILE)
    ;;
  temp_min)
    FILE=~/conky-sidebar/cache/forecast.json
    printf "%.0f" $(jq -r '.list['$2'].temp.min' $FILE)
    ;;
  temp_max)
    FILE=~/conky-sidebar/cache/forecast.json
    printf "%.0f" $(jq -r '.list['$2'].temp.max' $FILE)
    ;;
  pressure)
    echo -n $(jq -r '.main.pressure' $FILE)
    ;;
  humidity)
    echo -n $(jq -r '.main.humidity' $FILE)
    ;;
  wind_speed)
    SPEED=$(echo $(jq -r '.wind.speed' $FILE)*3.6 | bc)
    printf "%.0f" $SPEED
    ;;
  wind_degree)
    echo -n $(jq -r '.wind.deg' $FILE)
    ;;
  wind_degree_icon)
    DEGREE=$(jq -r '.wind.deg' $FILE)
    if [ "$DEGREE" == null ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_na'
    elif [ "$DEGREE" -gt 337 ] || [ "$DEGREE" -lt 23 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_up'
    elif [ "$DEGREE" -lt 68 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_up_right'
    elif [ "$DEGREE" -lt 113 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_right'
    elif [ "$DEGREE" -lt 158 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_down_right'
    elif [ "$DEGREE" -lt 203 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_down'
    elif [ "$DEGREE" -lt 248 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_down_left'
    elif [ "$DEGREE" -lt 293 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_left'
    elif [ "$DEGREE" -lt 338 ]; then
      ~/conky-sidebar/owm2utf8.sh 'wi_direction_up_left'
    fi
    ;;
  description)
    echo -n "$(jq -r '.weather[0].description' $FILE)" #"|$(jq -r '.weather[0].id' $FILE)"
    ;;
  *)
    echo $"Usage: $0 {icon_now|temp_now|day {0|1|2|...}|icon {0|1|2|...}|temp_min {0|1|2|...}|temp_max {0|1|2|...}|pressure|humidity|wind_speed|wind_degree|wind_degree_icon|description}"
esac
