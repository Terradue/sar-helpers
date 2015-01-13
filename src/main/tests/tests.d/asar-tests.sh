#!/bin/bash

#
#
# Tests for Envisat ASAR_IM__0P
#
#

#sourcing required dir
source /root/sar-helpers/src/main/resources/lib/sar-helpers.sh

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

testIs_ASAR() {
  out=`__is_ASAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  res=$?
  assertEquals "Failed to check ASAR on ASA_IM__0P" \
  "0" "$res"
}

testIs_ASAR_tar() {
  out=`__is_ASAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar`
  res=$?
  assertEquals "Failed to check ASAR on ASA_IM__0P tar" \
  "0" "$res"
}

testIs_ASAR_targz() {
  out=`__is_ASAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar.gz`
  res=$?
  assertEquals "Failed to check ASAR on ASA_IM__0P tar.gz" \
  "0" "$res"
}

testIs_ASAR_gz() {
  out=`__is_ASAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz`
  res=$?
  assertEquals "Failed to check ASAR on ASA_IM__0P gz" \
  "0" "$res"
}

testIs_ASAR_zip() {
  out=`__is_ASAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip`
  res=$?
  assertEquals "Failed to check ASAR on ASA_IM__0P zip" \
  "0" "$res"
}

testIs_ASAR_ERSE1() {
  out=`__is_ASAR $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  res=$?
  assertEquals "Failed to fail" \
  "1" "$res"
}

testIs_ASAR_ERSCEOS_tar() {
  out=`__is_ASAR $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  res=$?
  assertEquals "Failed to fail" \
  "1" "$res"
}

testIs_ASAR_ERSCEOS_targz() {
  out=`__is_ASAR $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar.gz`
  res=$?
  assertEquals "Failed to fail" \
  "1" "$res"
}

testIs_ASAR_ERSCEOS_zip() {
  out=`__is_ASAR $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.zip`
  res=$?
  assertEquals "Failed to fail" \
  "1" "$res"
}

testGetMission_ASAR() {
  out=`get_mission $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to detect Envisat ASAR " \
  "ASAR" "$out"
}

testGetTrack_TSX() {
  out=`get_track "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz"`
  assertEquals "Failed to retrieve TSX track" \
  "55" "$out"
}

testGetDirection_ASAR() {
  out=`get_direction "$_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1"`
  assertEquals "Failed to retrieve ASAR orbit direction" \
  "ASCENDING" "$out"
}

. ./common-tests.inc
