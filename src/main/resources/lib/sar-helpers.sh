#!/bin/bash

# /*!
#     This is a comment about FunctionName.
#  */
__get_MIMEtype() {
  set -o pipefail 
  local file=$1
  out=`file -bi $file | cut -d ";" -f1`
  [ $? != 0 ] && return 1
  echo $out
} 

#GetSensingDate

__get_archive_content() {
  local dataset="$1"
  local mimetype=`__get_MIMEtype $dataset`

  case $mimetype in
    "application/x-tar")
      content=`tar tf $dataset`
      res=$?
      ;;
    "application/octet-stream")
      content=$dataset
      res=$?
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $content
}

#GetCEOSSensingDate

__get_ASAR_sensing_date() {
  local dataset="$1"
  set -o pipefail
 
  local mimetype=`__get_MIMEtype $dataset`

  case $mimetype in
    "application/zip")
      sensingdate=`zcat -f $dataset | sed -b -n "10,10p" | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d` 
      res=$?
      ;;
    "application/octet-stream")
      sensingdate=`sed -b -n "10,10p" $dataset | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
      res=$?
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_ERSCEOS_sensing_date() {
  local dataset="$1"
  set -o pipefail

  local mimetype=`__get_MIMEtype $dataset`
  case $mimetype in
    "application/x-tar")
      lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
      tmpdir=/tmp/.`uuidgen`
      mkdir -p $tmpdir
      tar -xOf $dataset $lea > $tmpdir/lea_01.001   
      sensingdate=`metadata -dssr $tmpdir/lea_01.001 | grep "Zero-Doppler azimuth time center pixel"  | cut -c 40-63 | xargs -I {} date --date="{}" +"%Y%m%d"`
      res=$?
      rm -fr $tmpdir
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_ERSCEOS_mission() {
  local dataset="$1"
  set -o pipefail
  local mimetype=`__get_MIMEtype $dataset`
  case $mimetype in
    "application/x-tar")
      lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
      tmpdir=/tmp/.`uuidgen`
      mkdir -p $tmpdir
      tar -xOf $dataset $lea > $tmpdir/lea_01.001
      mission=`metadata -dssr $tmpdir/lea_01.001 | grep "MISSION ID" | sed 's/MISSION ID//' | tr -d "\t "`
      res=$?
      rm -fr $tmpdir
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $mission
}

__get_ERSCEOS_cycle() {
    local dataset="$1"
  set -o pipefail
  local mimetype=`__get_MIMEtype $dataset`
  case $mimetype in
    "application/x-tar")
      lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
      tmpdir=/tmp/.`uuidgen`
      mkdir -p $tmpdir
      tar -xOf $dataset $lea > $tmpdir/lea_01.001
      mission=`metadata -dssr $tmpdir/lea_01.001 | grep "MISSION ID" | sed 's/MISSION ID//' | tr -d "\t "`
      res=$?
      if [ $mission == ERS1 ]; then
        cycle=`__get_ERS1_cycle $tmpdir/lea_01.001`
      fi
      rm -fr $tmpdir
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $mission


}

#GetCSKSensingDate

#GetTSXSensingDate

#GetRadarsatSensingDate

#GetSentinel1SensingDate

#CreateAdoreEnv

#CreateGMTSAREnv

#CreateROIPACEnv

