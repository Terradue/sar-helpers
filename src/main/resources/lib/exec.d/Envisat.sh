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
function __get_N1_sensing_date() {
  local dataset="$1"
  local mimetype=$( __get_MIMEtype $dataset )

  case $mimetype in
    "application/x-tar")
      sensingdate=$( tar -Oxf $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d )
      res=$?
      ;;
    "application/zip")
      sensingdate=$( zcat -f $dataset | sed -b -n "10,10p" | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d ) 
      res=$?
      ;;
    "application/octet-stream")
      # TODO check if it's a ASA_IM__0
      sensingdate=$( sed -b -n "10,10p" $dataset | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d )
      res=$?
      ;;
    "application/x-gzip")
      content=$( zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }' )
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        sensingdate=$( tar -Oxf $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d )
        res=$( echo $res + $? | bc )
      else
        sensingdate=$( zcat $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d )
        res=$( echo $res + $? | bc )
      fi
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_ASAR_sensing_date() {
  __get_N1_sensing_date $@
}

__is_ASAR() {
  __is_N1E1E2 $@ "ASA_IM__0,ASA_IMS_1"
  return $?
}
