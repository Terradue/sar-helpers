#!/bin/bash

testDirectoryMIME() {
  out=`__get_MIMEtype $_ROOT`
  assertEquals "Failed on directory MIME type" \
  "application/x-directory" "$out"
}


testEnvisatMIME() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/octet-stream" "$out"
}

testMIMEzip() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/zip" "$out"
}

testMIMEtargz() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar.gz`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/x-gzip" "$out"
}

testMIMEtgz() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/x-gzip" "$out"
}

testMIMEgz() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/x-gzip" "$out"
}

testMIMEtar() {
  out=`__get_MIMEtype $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar`
  assertEquals "Failed to retrieve Envisat tar MIME type" \
  "application/x-tar" "$out"

  out=`__get_MIMEtype $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to retrieve ERS CEOS low-case tar MIME type" \
  "application/x-tar" "$out"
}

testASAsensingdate() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to retrieve Envisat ASAR sensing date" \
  "20120329" "$out"
}

testASAsensingdatezip() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip`
  assertEquals "Failed to retrieve Envisat ASAR sensing date" \
  "20120329" "$out"
}

testERSCEOSlowcase() {
  out=`__get_archive_content $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to retrieve ERS CEOS tar content" \
  "pablo/ pablo/TEMP_DN/ pablo/TEMP_DN/TMP_MARINA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/dat_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/lea_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/nul_dat.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/vdf_dat.001" "$out"
  
}

testERSCEOSlowcasesensingdate() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case sensing date" \
  "20000217" "$out"
}

testERSCEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case mission" \
  "ERS1" "$out"
}


setUp() {
  # load include to test
  export _ROOT=`dirname $0`
  . $_ROOT/../resources/lib/sar-helpers.sh
}

# load shunit2
. $SHUNIT2_HOME/src/shunit2
