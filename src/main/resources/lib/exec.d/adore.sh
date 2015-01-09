#!/bin/bash

set -o pipefail

# create_env_adore()

#
#
# ADORE Doris
#
#
__link_N1E1E2_adore() {
  local dataset="$1"
  local target="$2"  
  
  __link_N1E1E2_roipac ${dataset} ${target}
  
  return $?
}

__link_TSX_adore() {
  local dataset="$1"
  local target="$2"
  local sensing_date

  sensing_date=$( __get_TSX_sensing_date ${dataset} )
  [ $? != 0 ] && return 1

  local mimetype=`__get_MIMEtype $dataset`
  [ $? != 0 ] && return 1

  local leader=$( echo $content | tr " " "\n" | grep "\.xml$" | sed 's#.*/\(.*\)#\1#g' | grep "^T.*\.xml" )
  [ $? != 0 ] && return 1
  local leader_path=$( echo $content | tr " " "\n" | grep $leader )
  [ $? != 0 ] && return 1
  local cos=$( echo $content | tr " " "\n" | grep ".cos$" | sed 's#.*/\(.*\)#\1#g') 
  [ $? != 0 ] && return 1
  local cos_path=$( echo $content | tr " " "\n" | grep $cos )
  [ $? != 0 ] && return 1
 
  case $mimetype in
    "application/x-tar")
      tar -xOf $dataset $leader_path > $target/${sensing_date}.xml
      tar -xOf $dataset $cos_path > $target/${sensing_date}.cos
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $leader_path > $target/${sensing_date}.xml
      tar -xzOf $dataset $cos_path > $target/${sensing_date}.cos
      res=$?
      ;;
  esac

  return 0

}

create_env_adore() {
  local master="$1"
  local slave="$2"
  local target="$3"

  mission=`get_mission $master`

  mkdir -p $target/datafolder
  [ $? != 0 ] && return 1

  # TODO add check on mission_slave != mission_master (deal with tandem)
  for sar in $master $slave
  do
    case $mission in
      "ASAR")
        __link_N1E1E2_adore $sar $target/datafolder
        res=$?
        echo > ${target}/settings << EOF
m_in_method='ASAR'
dataFile="ASA*.N1"
s_in_method="ASAR"
EOF
        ;;
      "TSX" | "TDX")
        __link_TSX_adore $sar $target/datafolder
        res=$?
        echo > ${target}/settings << EOF
m_in_method='TSX'
s_in_method="TSX"
dataFile="*.cos"
leaderFile="*.xml"
EOF
        ;;
      "ERS1-CEOS" | "ERS2-CEOS")
        __link_ERSCEOS_ro $sar $target/raw
        res=$?
        ;;
      *)
        return 1
        ;;
      esac
  done

  return $?
}
