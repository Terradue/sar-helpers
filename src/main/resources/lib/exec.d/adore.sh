#!/bin/bash

set -o pipefail

# /*!
# __link_N1E1E2_adore() is an internal function to link Envisat ASAR or ERS-1/2 in Envisat format (.E1, .E2)
#
# @param $1 path to the Envisat ASAR or ERS-1/2 in Envisat format (.E1, .E2) dataset
# @param $2 target folder for creating the Doris/Adore structure and data 
#
# @return 0 on success, 1 on failure.
#
# @updated 2014-01-13
# */
__link_N1E1E2_adore() {
  # TODD add unit test
  local dataset="$1"
  local target="$2"
  local mimetype
  mimetype=$( __get_MIMEtype $dataset )
  local sensing_date
  sensing_date=$( get_sensing_date ${dataset}  ) 
  [ $? != 0 ] && return 1

  mkdir -p ${target}/${sensing_date}

  case ${mimetype} in
    "application/x-tar")
      tar -Oxf ${dataset} > ${target}/${sensing_date}/$( basename $dataset | sed 's/\.tar//' )
      res=$?
      ;;
    "application/octet-stream")
      dataset_folder=$( cd "$( dirname ${dataset} )" && pwd )
      cp ${dataset_folder}/$( basename ${dataset} ) ${target}/${sensing_date}/$( basename ${dataset} )
      res=$?
      #cd - &> /dev/null
      ;;
    "application/zip")
      zcat ${dataset} > ${target}/${sensing_date}/$( basename $dataset )
      res=$?
      ;;
      # TODO handle other mime types
    "application/x-gzip")
      content=`zcat -lv ${dataset} | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "${content}" =~ .*\.tar.* ]]; then
        tar -Oxf ${dataset} > $target/${sensing_date}/$( basename $dataset | sed 's/\.tar.gz//' | sed 's/\.tgz//' )
        res=`echo ${res} + $? | bc`
      else
        zcat $dataset > ${target}/${sensing_date}/$( basename $dataset | sed 's/\.gz//' )
        res=`echo ${res} + $? | bc`
      fi
  esac

  return ${res}
}

# /*!
# __link_TSX_adore() is an internal function to link Envisat ASAR or ERS-1/2 in Envisat format (.E1, .E2)
#
# @param $1 path to the TerraSAR-X dataset
# @param $2 target folder for creating the Doris/Adore structure and data
#
# @return 0 on success, 1 on failure.
#
# @updated 2014-01-13
# */
__link_TSX_adore() {
  
  local dataset="$1"
  local target="$2"
  local sensing_date

  sensing_date=$( __get_TSX_sensing_date ${dataset} )
  [ $? != 0 ] && return 1

  local mimetype=`__get_MIMEtype $dataset`
  [ $? != 0 ] && return 1

  local content
  content=$( __get_archive_content ${dataset} )
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

  # TODO check $res
  return 0

}


# /*!
# create_env_adore() is a public function to create the processing environment for Doris/Adore
#
# @param $1 path to the master dataset
# @param $2 path to the slave dataset
# @param $2 target folder for creating the Doris/Adore structure and data
#
# @return 0 on success, 1 on failure.
#
# @updated 2014-01-13
# */
create_env_adore() {
  
  local master="$1"
  local slave="$2"
  local target="$3"

  mission=`get_mission $master`

  mkdir -p $target/data
  [ $? != 0 ] && return 1

  local settings
  settings=${target}/settings.set

  local m_sensing_date
  m_sensing_date=$( get_sensing_date $master )
  res=$?

  local s_sensing_date
  s_sensing_date=$( get_sensing_date $slave )
  res=$?

  # TODO add check on mission_slave != mission_master (deal with tandem)
  case $mission in
    "ASAR")
      __link_N1E1E2_adore ${master} ${target}/data
      res=$?
      
      __link_N1E1E2_adore ${slave} ${target}/data
      res=$?

      cat > ${settings} << EOF
m_in_method='ASAR'
s_in_method='ASAR'
m_in_dat="${target}/data/${m_sensing_date}/$( basename ${master} )"
s_in_dat="${target}/data/${s_sensing_date}/$( basename ${slave} )"
master=${m_sensing_date}
slave=${s_sensing_date}
dataFile="ASA_*.N1"
m_in_vol="dummy"
m_in_lea="dummy"
m_in_null="dummy"
s_in_vol="dummy"
s_in_lea="dummy"
s_in_null="dummy"
scenes_include="( ${m_sensing_date} ${s_sensing_date} )"
EOF
      ;;
    "TSX" | "TDX")
      # TODO check $res
      __link_TSX_adore ${master} ${target}/data
      res=$?
  
      __link_TSX_adore ${slave} ${target}/data
      res=$?
  
      cat > ${settings} << EOF
m_in_method='TSX'
s_in_method="TSX"
m_in_dat="${target}/data/${m_sensing_date}.cos"
s_in_dat="${target}/data/${s_sensing_date}.cos"
m_in_lea="${target}/data/${m_sensing_date}.xml"
s_in_lea="${target}/data/${s_sensing_date}.xml"
master=${m_sensing_date}
slave=${s_sensing_date}
EOF
      ;;
    "ERS1-CEOS" | "ERS2-CEOS")
      __link_ERSCEOS_adore $sar $target/raw
      res=$?
      ;;
    *)
      return 1
      ;;
    esac

  [ -e ${settings} ] && sed -i  's/^/settings apply -r -q /' $settings  
  res=$?
   
  return $res

}
