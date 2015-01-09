#!/bin/bash

h5dump() {
  local params=$@

  local dataset
  
  dataset=`echo "$params" | tr " " "\n" | egrep -v "-"`
  
  cat ${dataset}
}

h5dump -A -x artifacts/CSKS2_RAW_B_HI_10_HH_RD_SF_20140121040327_20140121040334.h5 

__get_MIME_type() {
  echo "application/x-hdf"
}


