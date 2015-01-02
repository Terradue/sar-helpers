#!/bin/bash

get_MIMEtype() {
  
  local file=$1
  out=`file -bi $file | cut -d ";" -f1`
  echo a ${PIPESTATUS[0]}
  echo b ${PIPESTATUS[1]}
  echo c ${PIPESTATUS[*]} 
  [[ ${PIPESTATUS[0]} != 0 ]] || [[ ${PIPESTATUS[1]} != 0 ]] && return 1
  echo $out

} 

#GetSensingDate

#GetArchiveContent

#GetCEOSSensingDate

get_Envisat_sensing_date() {
  local dataset="$1"
  res=`sed -b -n "10,10p" $dataset | cut -b 16-26 | xargs -I {} date -d {} +%Y%m%d`
  
  echo $res
}

#GetCSKSensingDate

#GetTSXSensingDate

#GetRadarsatSensingDate

#GetSentinel1SensingDate

#CreateAdoreEnv

#CreateGMTSAREnv

#CreateROIPACEnv

