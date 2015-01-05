#!/bin/bash

# /*!
#     __get_MIMEtype() is an internal function
#     Its purpose is to find the mime type to allo invoking functions to handle correctly the input
#
#     @param $1 path to input file
#
#     @return Echoes MIME type to stdout on success, 1 on failure.
#
#     @updated 2014-01-05
#  */
__get_MIMEtype() {
  set -o pipefail 
  local file=$1
  mime=`file -bi $file`
  [[ $mime == *"(No such file or directory)"* ]] && return 1
  out=`echo $mime | cut -d ";" -f1`
  echo $out
} 

#GetSensingDate

# /*!
#     The function __get_archive_content() returns the content of an archive provided as argument
#
#     @updated 2003-03-15
#  */
__get_archive_content() {
  local dataset="$1"
  local mimetype=`__get_MIMEtype $dataset`
 set +x 
  case $mimetype in
    "application/x-tar")
      content=`tar tf $dataset`
      res=$?
      ;;
    "application/octet-stream")
      content=$dataset
      res=$?
      ;;
    "application/zip")
      content=`zipinfo -1 $dataset`
      res=$?
      ;;
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        content=`tar tfz $dataset`
        res=`echo $res + $? | bc`
      else
        content=${content#`dirname $content`\/}
        res=`echo $res + $? | bc`
      fi
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
    "application/x-tar")
      sensingdate=`tar -Oxf $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
      res=$?
      ;;
    "application/zip")
      sensingdate=`zcat -f $dataset | sed -b -n "10,10p" | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d` 
      res=$?
      ;;
    "application/octet-stream")
      # TODO check if it's a ASA_IM__0
      sensingdate=`sed -b -n "10,10p" $dataset | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
      res=$?
      ;;
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        sensingdate=`tar -Oxf $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
        res=`echo $res + $? | bc`
      else
        sensingdate=`zcat $dataset | sed '10q;d' | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
        res=`echo $res + $? | bc`
      fi
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_ERSCEOS_sensing_date() {
  local dataset="$1"
  set -o pipefail
  set +x
  
  local mimetype=`__get_MIMEtype $dataset`
  local lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
  local tmpdir=/tmp/.`uuidgen`
  mkdir -p $tmpdir

  case $mimetype in
    "application/x-tar")
      tar -xOf $dataset $lea > $tmpdir/lea_01.001   
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $lea > $tmpdir/lea_01.001
      res=$?
      ;;
  esac
  
  sensingdate=`metadata -dssr $tmpdir/lea_01.001 | grep "Zero-Doppler azimuth time center pixel"  | cut -c 40-63 | xargs -I {} date --date="{}" +"%Y%m%d"`
  res=`echo $res + $? | bc`
  rm -fr $tmpdir
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

# get_mission()

# get_sensing_date()

# get_cycle()

# get_track()

# __get_CSK_sensing_date()

# __get_TSX_sensing_date

# __get_Radarsat_sensing_date

# __get_Sentinel1_sensing_date

# create_env_adore()

# create_env_gmtsar()

# create_env_roipac()

