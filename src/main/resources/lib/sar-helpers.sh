#!/bin/bash

# /*!
#     __get_MIMEtype() is an internal function to determine the mime type. Invoking functions can then handle the input properly
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


# /*!
#      __get_ASAR_sensing_date() is an internal function to determine the mime type. Invoking functions can then handle the input properly
#
#      @param $1 path to input file
#
#      @return Echoes MIME type to stdout on success, 1 on failure.
#
#      @updated 2014-01-05
#  */
__get_N1_sensing_date() {
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

__get_ASAR_sensing_date() {
  __get_N1_sensing_date $@
}

__get_ERSE1_sensing_date() {
  __get_N1_sensing_date $@
}

__get_ERSE2_sensing_date() {
  __get_N1_sensing_date $@
}

__is_N1E1E2() {
  # NOTE will fail if zip has a folder structure
  local dataset="$1"
  local test="$2"
  set -o pipefail

  local mimetype=`__get_MIMEtype $dataset`

  case $mimetype in
    "application/x-tar")
      [ `tar tf $dataset | wc -l` != 1 ] && return 1  
      prefix=`tar -Oxf $dataset | sed -b '1q;d' | cut -b 10-18`
      res=$?
      ;;
    "application/zip")
      [ `zipinfo -1 $dataset | wc -l` != 1 ] && return 1
      prefix=`zcat -f $dataset | sed -b "1q;d" | cut -b 10-18`
      res=$?
      ;;
    "application/octet-stream")
      prefix=`sed -b "1q;d" $dataset | cut -b 10-18`
      res=$?
      ;;
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        prefix=`tar -Oxf $dataset | sed '1q;d' | cut -b 10-18`
        res=`echo $res + $? | bc`
      else
        prefix=`zcat $dataset | sed '1q;d' | cut -b 10-18`
        res=`echo $res + $? | bc`
      fi
      ;;
  esac

  [ $res != 0 ] && return 1
  [ $prefix == $test ] && return 0 || return 1
}

__is_ASAR() {
  __is_N1E1E2 $@ "ASA_IM__0"
  return $?
}

__is_SAR() {
  __is_N1E1E2 $@ "SAR_IM__0"
  return $?
}

__is_ERSCEOS() {
  local dataset="$1"
  set -o pipefail

  content="`__get_archive_content $dataset | tr " " "\n"`"
  res=$?
  lea=`echo $content | grep --ignore-case lea_01.001 | wc -l`
  res=`echo $res + $? | bc`
  dat=`echo $content | grep --ignore-case dat_01.001 | wc -l`
  res=`echo $res + $? | bc`
  nul=`echo $content | grep --ignore-case nul_dat.001 | wc -l`
  res=`echo $res + $? | bc`
  vdf=`echo $content | grep --ignore-case vdf_dat.001 | wc -l`
  res=`echo $res + $? | bc`
  [ $res != 0 ] && return 1
  [ $lea == 1 ] && [ $dat == 1 ] && [ $nul == 1 ] && [ $vdf == 1 ] && return 0  
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

__get_E1E2_mission() {
  # NOTE will fail if zip has a folder structure
  local dataset="$1"
  set -o pipefail

  local mimetype=`__get_MIMEtype $dataset`

  case $mimetype in
    "application/x-tar")
      [ `tar tf $dataset | wc -l` != 1 ] && return 1
      E1=`tar -Oxf $dataset | sed -b '1q;d' | grep ".E1" | wc -l`
      E2=`tar -Oxf $dataset | sed -b '1q;d' | grep ".E2" | wc -l`
      ;;
    "application/zip")
      [ `zipinfo -1 $dataset | wc -l` != 1 ] && return 1
      E1=`zcat -f $dataset | sed -b "1q;d" | grep ".E1" | wc -l`
      E2=`zcat -f $dataset | sed -b "1q;d" | grep ".E2" | wc -l`
      ;;
    "application/octet-stream")
      E1=`sed -b "1q;d" $dataset | grep ".E1" | wc -l`
      E2=`sed -b "1q;d" $dataset | grep ".E2" | wc -l`
      ;;
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      if [[ "$content" =~ .*\.tar.* ]]; then
        E1=`tar -Oxf $dataset | sed '1q;d' | grep ".E1" | wc -l`
        E2=`tar -Oxf $dataset | sed '1q;d' | grep ".E2" | wc -l`
      else
        E1=`zcat $dataset | sed '1q;d' | grep ".E1" | wc -l`
        E2=`zcat $dataset | sed '1q;d' | grep ".E2" | wc -l`
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

  set -o pipefail

  mission=`__get_ERSCEOS_field $dataset "$field" | sed 's/MISSION ID//' | tr -d "\t "`
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
  local absorbit=`__get_ERSCEOS_field $dataset "$field" | sed 's/[^0-9]*//g'`

  [[ -z "absorbit" ]] && {
    local field="SCENE DESIGNATOR"
    local absorbit=`__get_ERSCEOS_field $dataset "$field" | cut -d "=" -f 2 | cut -d "-" -f 1`
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

__detect_dataset() {
  local dataset="$1"

  __is_SAR $dataset &> /dev/null
  [ $? = 0 ] && { 
    mission=`__get_E1E2_mission $dataset`
    echo "${mission}-SAR"
    return 0
  }

  __is_ASAR $dataset &> /dev/null
  [ $? = 0 ] && {
    echo "ASAR" 
    return 0
  }

  __is_ERSCEOS $dataset &> /dev/null
  [ $? = 0 ] && {
    mission=`__get_ERSCEOS_mission $dataset`
    echo "${mission}-CEOS"
    return 0
  }
  return 1
}

get_mission() {
  __detect_dataset $@
}

get_sensing_date() {
  local dataset="$1"
  mission=`get_mission $dataset`
  
  [ $? != 0 ] && return 1

  case $mission in
    "ERS1-CEOS")
      sensingdate=`__get_ERSCEOS_sensing_date $dataset`
      res=$?
      ;;
    "ERS2-CEOS")
      sensingdate=`__get_ERSCEOS_sensing_date $dataset`
      res=$?
      ;;
    "ASAR")
      sensingdate=`__get_ASAR_sensing_date $dataset`
      res=$?
      ;;
    "ERS1-SAR")
      sensingdate=`__get_ERSE1_sensing_date $dataset`
      res=$?
      ;;
    "ERS2-SAR")
      sensingdate=`__get_ERSE2_sensing_date $dataset`
      res=$?
      ;;
    *)
      return 1
      ;;
  esac

  [ $res == 0 ] && echo $sensingdate || return 1
}


# get_cycle()

# get_track()

# __get_CSK_sensing_date()

# __get_TSX_sensing_date

# __get_Radarsat_sensing_date

# __get_Sentinel1_sensing_date

# create_env_adore()

__link_N1E1E2_gmtsar() {
  # TODD add unit test
  local dataset="$1"
  local target="$2"
  local mimetype=`__get_MIMEtype $dataset`
  
  mkdir -p $target

  case $mimetype in
    "application/x-tar")
      tar -Oxf $dataset > $target/`basename $dataset | sed 's/\.tar//'`.baq
      res=$?
      ;;
    "application/octet-stream")
      dataset_folder=$( cd "$( dirname $dataset )" && pwd )
      ln -s $dataset_folder/`basename $dataset` $target/`basename $dataset`.baq
      res=$?
      cd - &> /dev/null
      ;;
    "application/zip")
      zcat $dataset > $target/`basename $dataset`.baq
      res=$?
      ;;    
      # TODO handle other mime types
    "application/x-gzip")
      content=`zcat -lv $dataset | sed '2q;d' | awk '{ print $9 }'`
      res=$?
      if [[ "$content" =~ .*\.tar.* ]]; then
        tar -Oxf $dataset > $target/`basename $dataset | sed 's/\.tar.gz//' | sed 's/\.tgz//'`.baq
        res=`echo $res + $? | bc`
      else
        zcat $dataset > $target/`basename $dataset | sed 's/\.gz//'`.baq
        res=`echo $res + $? | bc`
      fi
  esac
 
  return $res
}


__link_ERSCEOS_gmtsar() {
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
      tar -xOf $dataset $lea > $target/${sensing_date}.ldr
      tar -xOf $dataset $dat > $target/${sensing_date}.dat
      res=$?
      ;;
    "application/x-gzip")
      tar -xzOf $dataset $lea > $target/${sensing_date}.ldr
      tar -xzOf $dataset $dat > $target/${sensing_date}.dat
      res=$?
      ;;
  esac
  return 0
}


create_env_gmtsar() {
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
        __link_N1E1E2_gmtsar $sar $target/raw
        res=$?
        ;;
      "ERS1-CEOS" | "ERS2-CEOS")
        __link_ERSCEOS_gmtsar $sar $target/raw
	res=$?
        ;;
     
      *)
        return 1
        ;;
      esac    
  done
  
  return $?
}


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
      "ERS1-CEOS" | "ERS2-CEOS")
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
