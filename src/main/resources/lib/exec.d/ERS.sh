#!/bin/bash

set -o pipefail

function __get_ERS1_SAR_sensing_date() {
  echo "$( __get_N1_sensing_date $@ )"
  return 0
}

function __get_ERS2_SAR_sensing_date() {
  echo "$( __get_N1_sensing_date $@ )"
  return 0
}

__is_SAR() {
  __is_N1E1E2 $@ "SAR_IM__0"
  return $?
}

__is_ERSCEOS() {
  local dataset="$1"

  content="$( __get_archive_content $dataset | tr " " "\n" )"
  res=$?
  lea=$( echo $content | grep --ignore-case lea_01.001 | wc -l )
  res=$( echo $res + $? | bc )
  dat=$( echo $content | grep --ignore-case dat_01.001 | wc -l )
  res=$( echo $res + $? | bc )
  nul=$( echo $content | grep --ignore-case nul_dat.001 | wc -l )
  res=$( echo $res + $? | bc )
  vdf=$( echo $content | grep --ignore-case vdf_dat.001 | wc -l )
  res=$( echo $res + $? | bc )
  [ $res != 0 ] && return 1
  [ $lea == 1 ] && [ $dat == 1 ] && [ $nul == 1 ] && [ $vdf == 1 ] && return 0  
}

__get_ERSCEOS_field() {
  local dataset="$1"
  local field="$2"

  local mimetype=$( __get_MIMEtype $dataset )
  local lea=$( __get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001 )
  local tmpdir=/tmp/.$( uuidgen )
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

  metadatavalue=$( metadata -dssr $tmplea | grep "$field" )
  res=$( echo $res + $? | bc )
  
  rm -fr $tmpdir
  [ $res != 0 ] && return 1
  echo $metadatavalue

}

__get_ERS1_CEOS_sensing_date()
{
   __get_ERSCEOS_sensing_date $@
}

 __get_ERS2_CEOS_sensing_date()
{
   __get_ERSCEOS_sensing_date $@
}

__get_ERSCEOS_sensing_date() {
  local dataset="$1"
  local field='Zero-Doppler azimuth time center pixel'

  sensingdate=$( __get_ERSCEOS_field $dataset "$field" | cut -c 40-63 | xargs -I {} date --date="{}" +"%Y%m%d" )
  res=$?
  [ $res != 0 ] && return 1
  echo $sensingdate
}

__get_E1E2_mission() {
  # NOTE will fail if zip has a folder structure
  local dataset="$1"
  local mimetype=$( __get_MIMEtype $dataset )

  case $mimetype in
    "application/x-tar")
      [ $( tar tf $dataset | wc -l ) != 1 ] && return 1
      E1=$( tar -Oxf $dataset | sed -b '1q;d' | grep ".E1" | wc -l )
      E2=$( tar -Oxf $dataset | sed -b '1q;d' | grep ".E2" | wc -l )
      ;;
    "application/zip")
      [ $( zipinfo -1 $dataset | wc -l ) != 1 ] && return 1
      E1=$( zcat -f $dataset | sed -b "1q;d" | grep ".E1" | wc -l )
      E2=$( zcat -f $dataset | sed -b "1q;d" | grep ".E2" | wc -l )
      ;;
    "application/octet-stream")
      E1=$( sed -b "1q;d" $dataset | grep ".E1" | wc -l )
      E2=$( sed -b "1q;d" $dataset | grep ".E2" | wc -l )
      ;;
    "application/x-gzip")
      content=$( zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }' )
      if [[ "$content" =~ .*\.tar.* ]]; then
        E1=$( tar -Oxf $dataset | sed '1q;d' | grep ".E1" | wc -l )
        E2=$( tar -Oxf $dataset | sed '1q;d' | grep ".E2" | wc -l )
      else
        E1=$( zcat $dataset | sed '1q;d' | grep ".E1" | wc -l )
        E2=$( zcat $dataset | sed '1q;d' | grep ".E2" | wc -l )
      fi
      ;;
  esac

  [ $E1 == 1 ] && { echo "ERS1"; return 0; }
  [ $E2 == 1 ] && { echo "ERS2"; return 0; }
  return 1
}

__get_ERSCEOS_mission() {
  local dataset="$1"
  local field='MISSION ID'

  mission=$( __get_ERSCEOS_field $dataset "$field" | sed 's/MISSION ID//' | tr -d "\t " )
  res=$?

  [ $res != 0 ] && return 1
  echo $mission
}

# /*!
#     __get_ERSCEOS_absorbit() is an internal function that extracts the absolute orbit of ERS-1/2 data in CEOS format
#     It uses metadata from ASF MapReady to read the LEA file 
#
#     @param $1 path to input file (in .tar, tar.gz or .tgz archive format)
#
#     @return Echoes the absolute orbit to stdout on success, -1 on failure.
#
#     @updated 2014-01-06
#  */
__get_ERSCEOS_absorbit() {
  local dataset="$1"
  local field="ORBIT NUMBER"
  local absorbit=$( __get_ERSCEOS_field $dataset "$field" | sed 's/[^0-9]*//g' )

  [[ -z "absorbit" ]] && {
    local field="SCENE DESIGNATOR"
    local absorbit=$( __get_ERSCEOS_field $dataset "$field" | cut -d "=" -f 2 | cut -d "-" -f 1 )
  }  

  [[ -z "absorbit" ]] && return -1

  echo $absorbit
}

# /*!
#     __get_ERSCEOS_cycle() is an internal function that extracts the absolute orbit of ERS-1/2 data in CEOS format
#     It uses metadata from ASF MapReady to read the LEA file
#
#     @param $1 path to input file (in .tar, tar.gz or .tgz archive format)
#
#     @return Echoes the absolute orbit to stdout on success, -1 on failure.
#
#     @updated 2014-01-06
#  */
__get_ERS1_cycle() {
  local dataset="$1"
  local absorbit=$( __get_ERSCEOS_absorbit $dataset )
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
  local absorbit=$( __get_ERSCEOS_absorbit $dataset )
  res=$?
  [ $res != 0 ] && return 1

  cycle=$( echo "($absorbit + 145 ) / 501" | bc )  
  res=$?
  [ $res != 0 ] && return 2
  echo $cycle
}

__get_ERSCEOS_cycle() {
  local dataset="$1"
 
  # check mission
  local mission=$( __get_ERSCEOS_mission $dataset )

  case $mission in
    "ERS1")
      cycle=$( __get_ERS1_cycle $dataset )
      res=$?
      ;;
    "ERS2")
      cycle=$( __get_ERS2_cycle $dataset )
      res=$?
      ;;
  esac

  [ $res != 0 ] && return 1
  echo $cycle

}

__get_ERS1_track() {
  local dataset="$1"
  local absorbit=$( __get_ERSCEOS_absorbit $dataset )
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
  local absorbit=$( __get_ERSCEOS_absorbit $dataset )
  res=$?
 
  [ $res != 0 ] && return 1
  
  cycle=$( __get_ERS2_cycle $dataset )
  track=$( echo "$absorbit + 146 - $cycle * 501" | bc )
  res=$?

  [ $res != 0 ] && return 2
  echo $track
}

__get_ERS1_CEOS_track() {
  __get_ERS1_track $@
  return $?
}

__get_ERS2_CEOS_track() {
  __get_ERS2_track $@
  return $?
}

