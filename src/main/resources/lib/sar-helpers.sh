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

__get_ERSCEOS_field() {
  local dataset="$1"
  local field="$2"
  set -o pipefail

  local mimetype=`__get_MIMEtype $dataset`
  local lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
  local tmpdir=/tmp/.`uuidgen`
  local tmplea=$tmpdir/lea_01.001

  mkdir -p $tmpdir
  
  case $mimetype in
    "application/x-tar")
      tar -xOf $dataset $lea > $tmplea
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $lea > $tmplea
      res=$?
      ;;
  esac

  metadatavalue=`metadata -dssr $tmplea | grep "$field"`
  res=`echo $res + $? | bc`
  
  rm -fr $tmpdir
  [ $res != 0 ] && return 1
  echo $metadatavalue

}


__get_ERSCEOS_sensing_date() {
  local dataset="$1"
  local field='Zero-Doppler azimuth time center pixel'

  set -o pipefail
  
  sensingdate=`__get_ERSCEOS_field $dataset "$field" | cut -c 40-63 | xargs -I {} date --date="{}" +"%Y%m%d"`
  res=$?
  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_ERSCEOS_mission() {
  local dataset="$1"
  local field='MISSION ID'

  set -o pipefail

  mission=`__get_ERSCEOS_field $dataset "$field" | sed 's/MISSION ID//' | tr -d "\t "`
  res=$?

  [ $res != 0 ] && return 1
  echo $mission
}

__get_ERSCEOS_absorbit() {
  local dataset="$1"
  local field="SCENE DESIGNATOR"

  local absorbit=`__get_ERSCEOS_field $dataset "$field" | cut -d "=" -f 2 | cut -d "-" -f 1`
  res=$?

  [ $res != 0 ] && return 1
  echo $absorbit
}


__get_ERS1_cycle() {
  local dataset="$1"
  
  local absorbit=`__get_ERSCEOS_absorbit $dataset`
  res=$?

  [ $res != 0 ] && return 1

  if [ $absorbit -ge 126 -a $absorbit -le 2103 ]; then
    cycle=$(( (absorbit + 3698)/43 ))
  elif [ $absorbit -ge 2354 -a $absorbit -le 3695 ]; then
    cycle=$(( (absorbit + 2334)/43 ))
  elif [ $absorbit -ge 3901 -a $absorbit -le 12707 ]; then
    cycle=$(( (absorbit + 3653)/501 ))
  elif [ $absorbit -ge 12754 -a $absorbit -le 14300 ]; then
    cycle=$(( (absorbit - 12728)/43 ))
  elif [ $absorbit -ge 14302 -a $absorbit -le 16745 ]; then
    cycle=$(( (absorbit - 12511)/2411 + 139 ))
  elif [ $absorbit -ge 16747 -a $absorbit -le 19247 ]; then
    cycle=$(( (absorbit - 14391)/2411 +141 ))
  elif [ $absorbit -ge 19248 ]; then
    cycle=$(( (absorbit - 19027)/501 + 144 ))
  fi
  
  echo $cycle 
}

__get_ERS2_cycle() {
  local dataset="$1"
  # TODO return code impact cycle information
  local absorbit=`__get_ERSCEOS_absorbit $dataset`
  res=$?
  [ $res != 0 ] && return 1

  cycle=`echo "($absorbit + 145 ) / 501" | bc`  
  res=$?
  [ $res != 0 ] && return 2
  echo $cycle
}

__get_ERSCEOS_cycle() {
  local dataset="$1"
 
  set -o pipefail

  # check mission
  local mission=`__get_ERSCEOS_mission $dataset`

  case $mission in
    "ERS1")
      cycle=`__get_ERS1_cycle $dataset`
      res=$?
      ;;
    "ERS2")
      cycle=`__get_ERS2_cycle $dataset`
      res=$?
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $cycle

}

__get_ERS1_track() {
  local dataset="$1"

  local absorbit=`__get_ERSCEOS_absorbit $dataset`
  res=$?

  [ $res != 0 ] && return 1

  if [ $absorbit -ge 126 -a $absorbit -le 2103 ]; then
    track=$(( (absorbit + 29 -126) % 43 ))
  elif [ $absorbit -ge 2354 -a $absorbit -le 3695 ]; then
    track=$(( (absorbit + 21 -2354) % 43 ))    
  elif [ $absorbit -ge 3901 -a $absorbit -le 12707 ]; then
    track=$(( (absorbit + 249 -3901) % 501 ))
  elif [ $absorbit -ge 12754 -a $absorbit -le 14300 ]; then
    track=$(( (absorbit + 27 -12754) % 43 ))
  elif [ $absorbit -ge 14302 -a $absorbit -le 16745 ]; then
    track=$(( (absorbit + 1792 -14302) % 2411 ))
  elif [ $absorbit -ge 16747 -a $absorbit -le 19247 ]; then
    track=$(( (absorbit + 2357 -16747) % 2411 ))
  elif [ $absorbit -ge 19248 ]; then
    track=$(( (absorbit + 222 -19248) % 501 ))
  fi

  echo $track
}

__get_ERS2_track() {
  local dataset="$1"
  # TODO return code impact track information
  local absorbit=`__get_ERSCEOS_absorbit $dataset`
  res=$?
  [ $res != 0 ] && return 1
  
  cycle=`__get_ERS2_cycle $dataset`

  track=`echo "$absorbit + 146 - $cycle * 501" | bc`
  res=$?
  [ $res != 0 ] && return 2
  echo $track
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

