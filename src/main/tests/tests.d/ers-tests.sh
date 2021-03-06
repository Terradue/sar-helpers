#!/bin/bash

#
#
# Tests for ERS-1 in CEOS format
#
#

export _ROOT=$( pwd )
source ${_ROOT}/../resources/lib/sar-helpers.sh

testERSCEOSlowcase() {
  out=`__get_archive_content $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to retrieve ERS CEOS tar content" \
  "pablo/ pablo/TEMP_DN/ pablo/TEMP_DN/TMP_MARINA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/ pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/dat_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/lea_01.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/nul_dat.001 pablo/TEMP_DN/TMP_MARINA/TERRAFIRMA/TMP/vdf_dat.001" "$out"

}

testContentZip() {
  out=$( basename `__get_archive_content $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip` )
  assertEquals "Failed to retrieve ASAR zip archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContentgz() {
  out=$( basename `__get_archive_content $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz` )
  assertEquals " ${FUNCNAME}:${LINENO} - Failed to retrieve ASAR gzip archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContenttgz() {
  out=$( basename `__get_archive_content $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz` )
  assertEquals "Failed to retrieve ASAR tgz archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}

testContenttargz() {
  out=$( basename `__get_archive_content $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar.gz` )
  assertEquals "Failed to retrieve ASAR tar.gz archive content" \
  "ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1" "$out"
}


testERS1CEOS_lowcase_sensingdate_tar() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case sensing date" \
  "20000217" "$out"
}

testERS2CEOS_lowcase_sensingdate_targz() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to ERS-2 CEOS tar low case sensing date in tar.gz" \
  "20100118" "$out"
}

testERS2CEOS_lowcase_sensingdate_targz() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar.gz`
  assertEquals "Failed to ERS CEOS tar low case sensing date in tar.gz" \
  "20000217" "$out"
}

testERS1CEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to extract ERS-1 CEOS tar low case mission" \
  "ERS1" "$out"
}

testERS2CEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to extract ERS-1 CEOS tar low case mission" \
  "ERS2" "$out"
}

testERSCEOSlowcaseabsorbit() {
  out=`__get_ERSCEOS_absorbit $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case absolute orbit" \
  "44928" "$out"
}

testERSCEOSlowcasecycle() {
  out=`__get_ERS1_cycle $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case cycle" \
  "195" "$out"
}

testERS1CEOSlowcasetrack() {
  out=`__get_ERS1_track $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case track" \
  "351" "$out"
}

# TODO add tests for ERS-2 in CEOS format
testERS2CEOS_lowcase_targz_track() {
  out=`__get_ERS2_track $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

testERS2CEOS_lowcase_tar_track() {
  out=`__get_ERS2_track $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

#
#
# Tests for ERS-1 in Envisat format
#
#
testERS1E1_sensingdate() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date" \
  "19960627" "$out"
}

testERS1E1_sensingdate_tar() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.tar`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - tar" \
  "19960627" "$out"
}

testERS1E1_sensingdate_zip() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.zip`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - zip" \
  "19960627" "$out"
}

testERS1E1_sensingdate_gzip() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.gz`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - gzip" \
  "19960627" "$out"
}

testERS1E1_mission() {
  out=`__get_E1E2_mission $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.gz`
  assertEquals "Failed to retrieve ERS-1 mission for ERS-1 in Envisat format" \
  "ERS1" "$out"
}

testERS1E1_sensingdate_targz() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.tar.gz`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - tar.gz" \
  "19960627" "$out"
}

testIs_SAR() {
  out=`__is_SAR $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  res=$?
  assertEquals "Failed to check SAR on SAR_IM__0P" \
  "0" "$res"
}

testIs_SAR_on_ASAR() {
  out=`__is_SAR $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  res=$?
  assertEquals "Failed to check SAR on SAR_IM__0P" \
  "1" "$res"
}

testIs_ERSCEOS() {
  out=`__is_ERSCEOS $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  res=$?
  assertEquals "Failed to check ERS CEOS" \
  "0" "$res"
}

testIs_ERSCEOS_on_ASAR() {
  out=`__is_SAR $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  res=$?
  assertEquals "Had to fail check ERS CEOS format on ASAR" \
  "1" "$res"
}

testGetSensingdate_ERS1E1() {
  out=`get_sensing_date $_ROOT/../artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date" \
  "19960627" "$out"
}

testGetTrack_ERS1CEOSlowcase_track() {
  out=`get_track $_ROOT/../artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case track" \
  "351" "$out"
}

testGetTrack_ERS2CEOS_lowcase_targz_track() {
  out=`get_track $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

testGetTrack_ERS2CEOS_lowcase_tar_track() {
  out=`get_track $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

. ./common-tests.inc
