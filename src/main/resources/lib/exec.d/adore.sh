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
