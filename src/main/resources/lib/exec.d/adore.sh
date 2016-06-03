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

  mkdir -p ${target}

  case ${mimetype} in
    "application/x-tar")
      tar -Oxf ${dataset} > ${target}/$( basename $dataset | sed 's/\.tar//' )
      res=$?
      ;;
    "application/octet-stream")
      dataset_folder=$( cd "$( dirname ${dataset} )" && pwd )
      mv ${dataset_folder}/$( basename ${dataset} ) ${target}/$( basename ${dataset} )
      res=$?
      #cd - &> /dev/null
      ;;
    "application/zip")
      zcat ${dataset} > ${target}/$( basename $dataset )
      res=$?
      ;;
      # TODO handle other mime types
    "application/x-gzip")
      content=`zcat -lv ${dataset} | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "${content}" =~ .*\.tar.* ]]; then
        tar -Oxf ${dataset} > $target/$( basename $dataset | sed 's/\.tar.gz//' | sed 's/\.tgz//' )
        res=`echo ${res} + $? | bc`
      else
        zcat $dataset > ${target}/$( basename $dataset | sed 's/\.gz//' )
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

__link_ERSCEOS_adore() {
  local dataset="$1"
  local target="$2"
  local mimetype
  mimetype=$( __get_MIMEtype ${dataset} )
 
  local content
  content=$( __get_archive_content ${dataset} )

  mkdir -p ${target}
  [ $? != 0 ] && return 1
 
  local lea=$( echo ${content} | tr " " "\n" | grep --ignore-case lea_01.001 )
  [ $? != 0 ] && return 1
  local dat=$( echo ${content} | tr " " "\n" | grep --ignore-case dat_01.001 )
  [ $? != 0 ] && return 1
  local vol=$( echo ${content} | tr " " "\n" | grep --ignore-case vdf_dat.001 )
  [ $? != 0 ] && return 1
  local nul=$( echo ${content} | tr " " "\n" | grep -E --ignore-case "nul_01.001|nul_dat.001" )
  [ $? != 0 ] && return 1

  case $mimetype in
    "application/x-tar")
      tar -xOf ${dataset} ${lea} > ${target}/LEA_01.001
      tar -xOf ${dataset} ${dat} > ${target}/DAT_01.001
      tar -xOf ${dataset} ${vol} > ${target}/VDF_DAT.001
      tar -xOf ${dataset} ${nul} > ${target}/NUL_01.001
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf ${dataset} ${lea} > ${target}/LEA_01.001
      tar -xzOf ${dataset} ${dat} > ${target}/DAT_01.001
      tar -xzOf ${dataset} ${vol} > ${target}/VDF_DAT.001
      tar -xzOf ${dataset} ${nul} > ${target}/NUL_01.001
      res=$?
      ;;
  esac
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

  [ -z ${master} ] || [ -z ${slave} ] || [ -z ${target} ] && return 1

  __check_mission ${master} ${slave}
  [ $? != 0 ] && {
    err "Missions do not match"
    return 1
  }

  __check_track ${master} ${slave}
    [ $? != 0 ] && {
    err "Tracks do not match"
    return 2
  }

  local m_sensing_date
  m_sensing_date=$( get_sensing_date $master )
  [ $? != 0 ] && return 3 

  local s_sensing_date
  s_sensing_date=$( get_sensing_date $slave )
  [ $? != 0 ] && return 3

  #changing the target to $target/$m_sensing_date_$s_sensing_date
  target="$target/${m_sensing_date}_${s_sensing_date}"

  mkdir -p $target/data
  [ $? != 0 ] && return 3
  mkdir -p $target/data/${m_sensing_date}
  [ $? != 0 ] && return 3
  mkdir -p $target/data/${s_sensing_date}
  [ $? != 0 ] && return 3

  local settings
  settings=${target}/settings.set

  # TODO add check on mission_slave != mission_master (deal with tandem)
  local mission
  mission=$( get_mission "${master}" )
  case $mission in
    "ASAR" | "ERS2_SAR")
      __link_N1E1E2_adore ${master} ${target}/data/${m_sensing_date}
      [ $? != 0 ] && return 3
      
      __link_N1E1E2_adore ${slave} ${target}/data/${s_sensing_date}
      [ $? != 0 ] && return 3

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
      __link_TSX_adore ${master} ${target}/data/${m_sensing_date}
      [ $? != 0 ] && return 3
  
      __link_TSX_adore ${slave} ${target}/data/${s_sensing_date}
      [ $? != 0 ] && return 3
  # TODO check settings
      cat > ${settings} << EOF
m_in_method='TSX'
s_in_method="TSX"
dataFile="*.cos"
leaderFile="T*.xml"
m_in_dat="${target}/data/${m_sensing_date}/${m_sensing_date}.cos"
s_in_dat="${target}/data/${s_sensing_date}/${s_sensing_date}.cos"
m_in_lea="${target}/data/${m_sensing_date}/${m_sensing_date}.xml"
s_in_lea="${target}/data/${s_sensing_date}/${s_sensing_date}.xml"
m_in_null="dummy"
s_in_null="dummy"
master=${m_sensing_date}
slave=${s_sensing_date}
scenes_include="( ${m_sensing_date} ${s_sensing_date} )"
EOF
      ;;
    "ERS1_CEOS" | "ERS2_CEOS")
      __link_ERSCEOS_adore ${master} ${target}/data/${m_sensing_date}
      [ $? != 0 ] && return 3

      __link_ERSCEOS_adore ${slave} ${target}/data/${s_sensing_date}
      [ $? != 0 ] && return 3

      cat > ${settings} << EOF
m_in_method='ERS'
s_in_method='ERS'
dataFile="DAT_01.001"
leaderFile="LEA_01.001"
volumeFile="VDF_DAT.001"
nullFile="NUL_01.001"
m_in_dat="${target}/data/${m_sensing_date}/DAT_01.001"
m_in_vol="${target}/data/${m_sensing_date}/VDF_DAT.001"
m_in_lea="${target}/data/${m_sensing_date}/LEA_01.001"
m_in_null=${target}/data/${m_sensing_date}/"NUL_01.001"
s_in_dat="${target}/data/${s_sensing_date}/DAT_01.001"
s_in_vol="${target}/data/${s_sensing_date}/VDF_DAT.001"
s_in_lea="${target}/data/${s_sensing_date}/LEA_01.001"
s_in_null="${target}/data/${s_sensing_date}/NUL_01.001"
master=${m_sensing_date}
slave=${s_sensing_date}
scenes_include="( ${m_sensing_date} ${s_sensing_date} )"
EOF
      [ $? != 0 ] && return 3
      ;;
    *)
      [ $? != 0 ] && return 3
      ;;
  esac

  #adds a common output folder
  #echo "outputFolder=${target}/${m_sensing_date}_${s_sensing_date}" >> ${settings}
  [ -e ${settings} ] && sed -i  's/^/settings apply -r -q /' $settings  
  [ $? != 0 ] && return 3
  
  echo ${target} 
  return 0

}
