#!/bin/bash

set -o pipefail

# /*!
#     __get_MIMEtype() is an internal function to determine the mime type. Invoking functions can then handle the input properly
#
#     @param $1 path to input file
#
#     @return Echoes MIME type to stdout on success, 1 on failure.
#
#     @updated 2014-01-05
#  */
function __get_MIMEtype() {
  local file=$1

  [ ! -e "$1" ] && return 1
  mime=$( file -bi ${file} )
  out=$( echo "${mime}" | cut -d ";" -f 1 )
  echo ${out}
} 

# /*!
#     The function __get_archive_content() returns the content of an archive provided as argument
#
#     @updated 2003-03-15
#  */
function __get_archive_content() {
  local dataset="$1"
  local mimetype=$( __get_MIMEtype "${dataset}" )

  #set +x 
  case ${mimetype} in
    "application/x-tar")
      content=$( tar tf ${dataset} )
      res=$?
      ;;
    "application/octet-stream")
      content=${dataset}
      res=$?
      ;;
    "application/zip")
      content=$( zipinfo -1 ${dataset} )
      res=$?
      ;;
    "application/x-gzip")
      content=$( zcat -lv ${dataset} | sed '2q;d' | awk '{ print $9 }' )
      res=$?
      if [[ "${content}" =~ .*\.tar.* ]]; then
        content=$( tar tfz ${dataset} )
        res=$( echo ${res} + $? | bc )
      else
        content=${content#$( dirname $content )\/}
        res=$( echo ${res} + $? | bc )
      fi
      ;;
  esac

  [ ${res} != 0 ] && return 1
  echo ${content}
}

__is_N1E1E2() {
  # NOTE will fail if zip has a folder structure
  local dataset="$1"
  local test="$2"
  local mimetype=$( __get_MIMEtype $dataset )

  case $mimetype in
    "application/x-tar")
      [ $( tar tf $dataset | wc -l ) != 1 ] && return 1  
      prefix=$( tar -Oxf $dataset | sed -b '1q;d' | cut -b 10-18 )
      res=$?
      ;;
    "application/zip")
      [ $( zipinfo -1 $dataset | wc -l ) != 1 ] && return 1
      prefix=$( zcat -f $dataset | sed -b "1q;d" | cut -b 10-18 )
      res=$?
      ;;
    "application/octet-stream")
      prefix=$( sed -b "1q;d" $dataset | cut -b 10-18 )
      res=$?
      ;;
    "application/x-gzip")
      content=$( zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }' )
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        prefix=$( tar -Oxf $dataset | sed '1q;d' | cut -b 10-18 )
        res=$( echo $res + $? | bc )
      else
        prefix=$( zcat $dataset | sed '1q;d' | cut -b 10-18 )
        res=$( echo $res + $? | bc )
      fi
      ;;
  esac

  [ $res != 0 ] && return 1
  [ $prefix == $test ] && return 0 || return 1
}

__detect_dataset() {
  local dataset="$1"

  __is_SAR $dataset &> /dev/null
  [ $? = 0 ] && { 
    mission=$( __get_E1E2_mission $dataset )
    echo "${mission}_SAR"
    return 0
  }

  __is_ASAR $dataset &> /dev/null
  [ $? = 0 ] && {
    echo "ASAR" 
    return 0
  }

  __is_ERSCEOS $dataset &> /dev/null
  [ $? = 0 ] && {
    mission=$( __get_ERSCEOS_mission $dataset )
    echo "${mission}_CEOS"
    return 0
  }
  return 1
}
