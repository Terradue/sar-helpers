#!/bin/bash

set -o pipefail

get_mission() {
  __detect_dataset $@
}

get_sensing_date() {
  local dataset="$1"

  mission=$( get_mission $dataset )
  [ $? != 0 ] && return 1

  #let's check if a function for the specific mission exists
  type __get_${mission}_sensing_date &> /dev/null
  [ $? != 0 ] && return 1

  sensingdate=$( __get_${mission}_sensing_date $dataset )
  res=$?
  [ $res == 0 ] && echo $sensingdate || return 1
}

# get_cycle()

# get_track()
