#!/bin/bash

set -o pipefail

#
#
# ROI_PAC
#
#
__link_N1E1E2_roipac() {
  # TODD add unit test
  local dataset="$1"
  local target="$2"
  local mimetype=`__get_MIMEtype $dataset`

  mkdir -p $target

  case $mimetype in
    "application/x-tar")
      tar -Oxf $dataset > $target/`basename $dataset | sed 's/\.tar//'`
      res=$?
      ;;
    "application/octet-stream")
      dataset_folder=$( cd "$( dirname $dataset )" && pwd )
      ln -s $dataset_folder/`basename $dataset` $target/`basename $dataset`
      res=$?
      cd - &> /dev/null
      ;;
    "application/zip")
      zcat $dataset > $target/`basename $dataset`
      res=$?
      ;;
      # TODO handle other mime types
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        tar -Oxf $dataset > $target/`basename $dataset | sed 's/\.tar.gz//' | sed 's/\.tgz//'`
        res=`echo $res + $? | bc`
      else
        zcat $dataset > $target/`basename $dataset | sed 's/\.gz//'`
        res=`echo $res + $? | bc`
      fi
  esac

  return $res
}

__link_ERSCEOS_roipac() {
  local dataset="$1"
  local target="$2"
  local mimetype=`__get_MIMEtype $dataset`
  local lea=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case lea_01.001`
  [ $? != 0 ] && return 1
  local dat=`__get_archive_content $dataset | tr " " "\n" | grep --ignore-case dat_01.001`
  [ $? != 0 ] && return 1
  local sensing_date=`__get_ERSCEOS_sensing_date $dataset`
  [ $? != 0 ] && return 1

  case $mimetype in
    "application/x-tar")
      tar -xOf $dataset $lea > $target/SARLEADER_${sensing_date}
      tar -xOf $dataset $dat > $target/IMAGERY_${sensing_date}
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $lea > $target/SARLEADER_${sensing_date}
      tar -xzOf $dataset $dat > $target/IMAGERY_${sensing_date}
      res=$?
      ;;
  esac
  return 0
}

create_env_roipac() {
  local master="$1"
  local slave="$2"
  local target="$3"

  mission=`get_mission $master`

  mkdir -p $target/raw
  [ $? != 0 ] && return 1

  # TODO add check on mission_slave != mission_master (deal with tandem)
  for sar in $master $slave
  do
    case $mission in
      "ASAR")
        __link_N1E1E2_roipac $sar $target/raw
        res=$?
        ;;
      "ERS1_CEOS" | "ERS2_CEOS")
        __link_ERSCEOS_roipac $sar $target/raw
        res=$?
        ;;
      *)
        return 1
        ;;
      esac
  done

  return $?
}
