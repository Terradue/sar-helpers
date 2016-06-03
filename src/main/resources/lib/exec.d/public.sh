#!/bin/bash
#set -x 
set -o pipefail

get_mission() {
  __detect_dataset $@
}

get_sensing_date() {
  local dataset="$1"
  local metadata_field
  metadata_field="sensing_date"

  __get_metadata_value ${dataset} ${metadata_field} || return 1
#  res=$?
#  [ $res == 0 ] && echo ${metadata_value} || return 1

}

get_track() {
  local dataset="$1"
  local metadata_field
  metadata_field="track"

#  metadata_value=__get_metadata_value ${dataset} ${metadata_field}
#  res=$?
#  [ $res == 0 ] && echo ${metadata_value} || return 1
__get_metadata_value ${dataset} ${metadata_field} || return 1

}

get_direction() {
  local dataset="$1"
  local metadata_field
  metadata_field="direction"
 
  __get_metadata_value ${dataset} ${metadata_field}
  #res=$?
  #[ $res == 0 ] && echo ${metadata_value} || return 1

}

get_cycle() {
  local dataset="$1"
  local metadata_field
  metadata_field="cycle"

  __get_metadata_value ${dataset} ${metadata_field}
  #res=$?
  #[ $res == 0 ] && echo ${metadata_value} || return 1

}
