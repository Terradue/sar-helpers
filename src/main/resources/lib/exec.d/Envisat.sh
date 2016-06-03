#!/bin/bash

set -o pipefail

# /*!
#      __get_ASAR_sensing_date() is an internal function to determine the mime type. Invoking functions can then handle the input properly
#
#      @param $1 path to input file
#
#      @return Echoes MIME type to stdout on success, 1 on failure.
#
#      @updated 2014-01-05
#  */

function __get_N1_field() {
  local dataset="$2"
  local field="$1"
  local mimetype=$( __get_MIMEtype $dataset )

  case $mimetype in
    "application/x-tar")
      myfield=$( tar -Oxf $dataset | head -90 | grep ${field} | sed 's#.*"\(.*\)".*#\1#g' | cut -d "=" -f 2- )
      res=$?
      ;;
    "application/zip")
      myfield=$( zcat -f $dataset | head -90 | grep ${field} | sed 's#.*"\(.*\)".*#\1#g' | cut -d "=" -f 2- ) 
      res=$?
      ;;
    "application/octet-stream")
      # TODO check if it's a ASA_IM__0
      myfield=$( head -90 $dataset | grep ${field} | sed 's#.*"\(.*\)".*#\1#g' | cut -d "=" -f 2- )
      res=$?
      ;;
    "application/x-gzip")
      content=$( zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }' )
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        myfield=$( tar -Oxf $dataset | head -90 | grep ${field} | sed 's#.*"\(.*\)".*#\1#g' | cut -d "=" -f 2- )
        res=$( echo $res + $? | bc )
      else
        myfield=$( zcat $dataset | head -90 | grep ${field} | sed 's#.*"\(.*\)".*#\1#g' | cut -d "=" -f 2- )
        res=$( echo $res + $? | bc )
      fi
      ;;
  esac

  [ ! -z $res ] && [ $res != 0 ] && [ $res != 141 ] && return 1
  echo "${myfield}"
}

__get_ASAR_sensing_date() {
  __get_N1_field "SENSING_START" $@ | cut -b 1-14 | xargs -I {} date -d {} +%Y%m%d
}

__get_ASAR_track() {
  __get_N1_field "REL_ORBIT" $@ | sed 's#.*[0*]\(.*\)#\1#g'
}

__get_ASAR_direction() {
  __get_N1_field "REL_ORBIT" $@ 
}

__is_ASAR() {
  __is_N1E1E2 $@ "ASA_IM__0,ASA_IMS_1"
  return $?
}
