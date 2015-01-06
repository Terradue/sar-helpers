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

testASAsensingdatetar() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar`
  assertEquals "Failed to retrieve Envisat ASAR sensing date" \
  "20120329" "$out"
}

testASAsensingdatezip() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip`
  assertEquals "Failed to retrieve Envisat ASAR sensing date" \
  "20120329" "$out"
}

testASAsensingdategzip() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz`
  assertEquals "Failed to retrieve Envisat ASAR sensing date in gz" \
  "20120329" "$out"
}

testASAsensingdatetargz() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar.gz`
  assertEquals "Failed to retrieve Envisat ASAR sensing date in tar.gz" \
  "20120329" "$out"
}

testASAsensingdatetgz() {
  out=`__get_ASAR_sensing_date $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz`
  assertEquals "Failed to retrieve Envisat ASAR sensing date in tgz" \
  "20120329" "$out"
}

# __get_archive_content
testERSCEOSlowcase() {
  out=`__get_archive_content $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to retrieve ERS CEOS tar content" \
  "pablo/ pablo/TEMP_DN/ pablo/TEMP_DN/TMP_MARINA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/dat_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/lea_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/nul_dat.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/vdf_dat.001" "$out"
  
}

testContentZip() {
  out=`__get_archive_content $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip`
  assertEquals "Failed to retrieve ASAR zip archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContentgz() {
  out=`__get_archive_content $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz`
  assertEquals "Failed to retrieve ASAR gzip archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContenttgz() {
  out=`__get_archive_content $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz`
  assertEquals "Failed to retrieve ASAR tgz archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContenttargz() {
  out=`__get_archive_content $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar.gz`
  assertEquals "Failed to retrieve ASAR tar.gz archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}


testERSCEOSlowcasesensingdatetar() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case sensing date" \
  "20000217" "$out"
}

testERSCEOSlowcasesensingdatetargz() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar.gz`
  assertEquals "Failed to ERS CEOS tar low case sensing date in tar.gz" \
  "20000217" "$out"
}

testERSCEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case mission" \
  "ERS1" "$out"
}

testERSCEOSlowcaseabsorbit() {
  out=`__get_ERSCEOS_absorbit $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar` 
  assertEquals "Failed to ERS CEOS tar low case absolute orbit" \
  "44928" "$out"
}

testERSCEOSlowcasecycle() {
  out=`__get_ERS1_cycle $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case cycle" \
  "195" "$out"
}

testERSCEOSlowcasetrack() {
  out=`__get_ERS1_track $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case track" \
  "351" "$out"
}

# TODO add tests for ERS-2 in CEOS format

setUp() {
  # load include to test
  export _ROOT=`dirname $0`
  . $_ROOT/../resources/lib/sar-helpers.sh
}

# load shunit2
. $SHUNIT2_HOME/src/shunit2
