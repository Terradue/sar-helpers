
set -o pipefail

__get_TSX_leader() {

  set +x  
  local dataset="$1"
  local target="$2"

  local mimetype
  mimetype=$( __get_MIMEtype $dataset )

  local content=$( __get_archive_content $dataset )
  local leader=$( echo $content | tr " " "\n" | grep "\.xml$" | sed 's#.*/\(.*\)#\1#g' | grep "^T.*\.xml" )
  local leader_path=$( echo $content | tr " " "\n" | grep $leader )

  case $mimetype in
    "application/x-tar")
      tar -xOf $dataset $leader_path > $target/$leader
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $leader_path > $target/$leader
      res=$?
      ;;
  esac
 
  [ $res != 0 ] && return 1
  echo $target/$leader
}

__get_TSX_field() {

  set +x
  local dataset="$1"
  local xpath="$2"

  local mimetype
  mimetype=$( __get_MIMEtype ${dataset} )
  
  local tmpdir=/tmp/.$( uuidgen )
  mkdir -p $tmpdir

  local leader=$( __get_TSX_leader ${dataset} ${tmpdir} )

  metadata_value=$( xmllint --xpath "${xpath}" ${leader} )
  res=$?
  
  rm -fr $tmpdir
  
  [ $res != 0 ] && return 1
  echo $metadata_value
}


# /*!
# __get_TSX_sensing_date() is an internal function to extract TerraSAR-X sensing day
#
# @param $1 path to the TerraSAR-X dataset
#
# @return Echoes the sensing day in YYYYMMDD format, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
function __get_TSX_sensing_date() {
  set +x

  local dataset="$1"
  local xpath
  xpath='//level1Product/productInfo/sceneInfo/start/timeUTC/text()'
 
  metadata_value=$( __get_TSX_field $dataset $xpath | tr -d "Z" |  xargs -I {} date --date="{}" +"%Y%m%d" )
  res=$?

  [ $res != 0 ] && return 1
  echo $metadata_value
}

__get_TDX_sensing_date() {
  __get_TSX_sensing_date $@
  return $?
}

# /*!
# __get_TSX_mission() is an internal function to extract TerraSAR-X mission 
#
# @param $1 path to the TerraSAR-X dataset
#
# @return Echoes the mission, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
function __get_TSX_mission() {
  set +x

  local dataset="$1"
  local xpath
  xpath='//level1Product/productInfo/missionInfo/mission/text()'

  metadata_value=$( __get_TSX_field $dataset $xpath | sed 's/-1//' )
  res=$?

  [ $res != 0 ] && return 1
  echo $metadata_value
}

__get_TDX_mission() {
  __get_TSX_mission $@
  return $?
}

# /*!
# __get_TSX_track() is an internal function to extract TerraSAR-X track (relative orbit)
#
# @param $1 path to the TerraSAR-X dataset
#
# @return Echoes the relative in YYYYMMDD format, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
__get_TSX_track() {
  set +x

  local dataset="$1"
  local xpath
  xpath="//level1Product/productInfo/missionInfo/relOrbit/text()"

  metadata_value=$( __get_TSX_field $dataset $xpath )
  res=$?

  [ $res != 0 ] && return 1
  echo $metadata_value
}

__get_TDX_track() {
  __get_TSX_track $@
  return $?
}

# /*!
# __get_TSX_cycle() is an internal function to extract TerraSAR-X cycle
#
# @param $1 path to the TerraSAR-X dataset
#
# @return cycle, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
function __get_TSX_cycle() {
  set +x

  local dataset="$1"
  local xpath
  xpath="//level1Product/productInfo/missionInfo/orbitCycle/text()"

  metadata_value=$( __get_TSX_field ${dataset} ${xpath} )
  res=$?

  [ $res != 0 ] && return 1
  echo ${metadata_value}
}

__get_TDX_cycle() {
  __get_TSX_cycle $@
  return $?
}

# /*!
# __get_TSX_direction() is an internal function to extract TerraSAR-X acquisition direction: ASCENDING or DESCENDING
#
# @param $1 path to the TerraSAR-X dataset
#
# @return ASCENDING or DESCENDING, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
function __get_TSX_direction() {
  set +x

  local dataset="$1"
  local xpath
  xpath='//level1Product/productInfo/missionInfo/orbitDirection/text()'

  metadata_value=$( __get_TSX_field ${dataset} ${xpath} )
  res=$?

  [ $res != 0 ] && return 1
  echo ${metadata_value}
}

__get_TDX_direction() {
  __get_TSX_direction $@
  return $?
}

# /*!
# __get_TSX_orbit() is an internal function to extract TerraSAR-X absolute orbit
#
# @param $1 path to the TerraSAR-X dataset
#
# @return absolute orbit, 0 on success, 1 on failure.
#
# @updated 2014-01-09
# */
function __get_TSX_orbit() {
  set +x

  local dataset="$1"
  local xpath
  xpath='//level1Product/productInfo/missionInfo/absOrbit/text()'

  metadata_value=$( __get_TSX_field ${dataset} ${xpath} )
  res=$?

  [ $res != 0 ] && return 1
  echo ${metadata_value}

}

__get_TDX_orbit() {
  __get_TSX_orbit $@
  return $?
}

__is_TSX() {

  local dataset="$1"
 
  content="$( __get_archive_content $dataset | tr " " "\n" )"
  res=$?

  cos=$( echo $content | grep '.cos' | wc -l )
  res=$( echo $res + $? | bc )
  
  [ $res != 0 ] && return 1
  [ $cos == 1 ] && return 0

}

