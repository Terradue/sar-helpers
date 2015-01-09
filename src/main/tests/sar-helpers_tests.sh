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

#
#
# Tests for Envisat ASAR_IM__0P
#
#
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
#
#
# Tests for ERS-1 in CEOS format
#
#
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


testERS1CEOS_lowcase_sensingdate_tar() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case sensing date" \
  "20000217" "$out"
}

testERS2CEOS_lowcase_sensingdate_targz() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to ERS-2 CEOS tar low case sensing date in tar.gz" \
  "20100118" "$out"
}

testERS2CEOS_lowcase_sensingdate_targz() {
  out=`__get_ERSCEOS_sensing_date $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar.gz`
  assertEquals "Failed to ERS CEOS tar low case sensing date in tar.gz" \
  "20000217" "$out"
}

testERS1CEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to extract ERS-1 CEOS tar low case mission" \
  "ERS1" "$out"
}

testERS2CEOSlowcasemission() {
  out=`__get_ERSCEOS_mission $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to extract ERS-1 CEOS tar low case mission" \
  "ERS2" "$out"
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

testERS1CEOSlowcasetrack() {
  out=`__get_ERS1_track $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to ERS CEOS tar low case track" \
  "351" "$out"
}

# TODO add tests for ERS-2 in CEOS format
testERS2CEOS_lowcase_targz_track() {
  out=`__get_ERS2_track $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

testERS2CEOS_lowcase_tar_track() {
  out=`__get_ERS2_track $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  assertEquals "Failed to ERS-2 CEOS tar low case track" \
  "98" "$out"
}

#
#
# Tests for ERS-1 in Envisat format
#
#
testERS1E1_sensingdate() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date" \
  "19960627" "$out"
}

testERS1E1_sensingdate_tar() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.tar`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - tar" \
  "19960627" "$out"
}

testERS1E1_sensingdate_zip() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.zip`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - zip" \
  "19960627" "$out"
}

testERS1E1_sensingdate_gzip() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.gz`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - gzip" \
  "19960627" "$out"
}

testERS1E1_mission() {
  out=`__get_E1E2_mission $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.gz`
  assertEquals "Failed to retrieve ERS-1 mission for ERS-1 in Envisat format" \
  "ERS1" "$out"
}

testERS1E1_sensingdate_targz() {
  out=`__get_ERS1_SAR_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1.tar.gz`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date - tar.gz" \
  "19960627" "$out"
}

testIs_SAR() {
  out=`__is_SAR $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  res=$?
  assertEquals "Failed to check SAR on SAR_IM__0P" \
  "0" "$res"
}

testIs_SAR_on_ASAR() {
  out=`__is_SAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  res=$?
  assertEquals "Failed to check SAR on SAR_IM__0P" \
  "1" "$res"
}

testIs_ERSCEOS() {
  out=`__is_ERSCEOS $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  res=$?
  assertEquals "Failed to check ERS CEOS" \
  "0" "$res"
}

testIs_ERSCEOS_on_ASAR() {
  out=`__is_SAR $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  res=$?
  assertEquals "Had to fail check ERS CEOS format on ASAR" \
  "1" "$res"
}

#
#
# detection
#
#
testDetect_ASAR() {
  out=`__detect_dataset $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to detect Envisat ASAR " \
  "ASAR" "$out"
}

testDetect_SARE1() {
  out=`__detect_dataset $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  assertEquals "Failed to detect ERS-1 in Envisat format (.E1) " \
  "ERS1_SAR" "$out"
}

testDetect_ERS2_CEOS() {
  out=`__detect_dataset $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar`
  assertEquals "Failed to detect ERS-2 in CEOS format " \
  "ERS2_CEOS" "$out"
}

testDetect_ERS1_CEOS() {
  out=`__detect_dataset $_ROOT/artifacts/ER01_SAR_RAW_0P_20000217T095726_20000217T095743_44928.CEOS_low_case.tar`
  assertEquals "Failed to detect ERS-1 in CEOS format " \
  "ERS1_CEOS" "$out"
}

#
#
# public functions
#
#
testGetMission_ASAR() {
  out=`get_mission $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to detect Envisat ASAR " \
  "ASAR" "$out"
}

testGetSensingdate_ERS1E1() {
  out=`get_sensing_date $_ROOT/artifacts/SAR_IM__0PXASI19960627_211354_00000017G157_00358_25897_9069.E1`
  assertEquals "Failed to retrieve ERS-1 in Envisat format sensing date" \
  "19960627" "$out"
}

#
#
# GMTSAR
#
#

testLinkASAR_gmtsar() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1 $_TEST/raw`
  res=$? 
  assertEquals "link ASAR GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_tar() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tar GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_zip() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip $_TEST/raw`
  res=$?
  assertEquals "extract ASAR zip GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_gz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR gz GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tgz GMTSAR failed" \
  "0" "$res"
}

testLinkERSCEOS_gmtsar_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_gmtsar $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tgz GMTSAR failed" \
  "0" "$res"
}

testLinkERSCEOS_gmtsar_tar() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_gmtsar $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tar GMTSAR failed" \
  "0" "$res"
  find $_TEST
}

testCreate_env_gmtsar_ASAR() {
  mkdir -p $_TEST
  master="$_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz"
  slave="$_ROOT/artifacts/ASA_IM__0CNPDE20111031_071059_000000163108_00121_50566_4642.N1"
  create_env_gmtsar $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ASAR" \
  "0" "$res"
}

testCreate_env_gmtsar_ERSCEOS() {
  mkdir -p $_TEST
  master="$_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz"
  slave="$_ROOT/artifacts/ER02_SAR_RAW_0P_20060807T174703_20060807T174719_ESR_59070.CEOS.tgz"
  create_env_gmtsar $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ERS CEOS" \
  "0" "$res"
  find $_TEST
}

#
#
# ROI_PAC
#
#
testLinkASAR_roipac() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_roipac $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1 $_TEST/raw`
  res=$?
  assertEquals "link ASAR ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkASAR_roipac_tar() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_roipac $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tar ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkASAR_roipac_zip() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_roipac $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip $_TEST/raw`
  res=$?
  assertEquals "extract ASAR zip ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkASAR_roipac_gz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_roipac $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR gz ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkASAR_roipac_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_roipac $_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tgz ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkERSCEOS_roipac_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_roipac $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tgz ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testLinkERSCEOS_roipac_tar() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_roipac $_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tar ROI_PAC failed" \
  "0" "$res"
  find $_TEST
}

testCreate_env_roipac_ASAR() {
  mkdir -p $_TEST
  master="$_ROOT/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz"
  slave="$_ROOT/artifacts/ASA_IM__0CNPDE20111031_071059_000000163108_00121_50566_4642.N1"
  create_env_roipac $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ASAR" \
  "0" "$res"
  find $_TEST
}

testCreate_env_roipac_ERSCEOS() {
  mkdir -p $_TEST
  master="$_ROOT/artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz"
  slave="$_ROOT/artifacts/ER02_SAR_RAW_0P_20060807T174703_20060807T174719_ESR_59070.CEOS.tgz"
  create_env_roipac $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ERS CEOS" \
  "0" "$res"
  find $_TEST
}

#
#
# TSX TerraSAR-X
#
#
testGetTSX_sensing_date() {
  out=$( __get_TSX_sensing_date "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract sensing date from TerraSAR-X" \
  "20140212" "$out"
}

testGetTSX_mission() {
  out=$( __get_TSX_mission "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract mission from TerraSAR-X" \
  "TDX-1" "$out"
}

testGetTSX_track() {
  out=$( __get_TSX_track "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract track from TerraSAR-X" \
  "55" "$out"
}

testGetTSX_cycle() {
  out=$( __get_TSX_cycle "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract cycle from TerraSAR-X" \
  "222" "$out"
}

testGetTSX_direction() {
  out=$( __get_TSX_direction "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract direction from TerraSAR-X" \
  "ASCENDING" "$out"
}

testGetTSX_orbit() {
  out=$( __get_TSX_orbit "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract absolute orbit from TerraSAR-X" \
  "20232" "$out"
}

testIsTSX() {
  out=$( __is_TSX "$_ROOT/artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to detect TSX" \
  "0" "$res"
}


setUp() {
  # load include to test
  export _ROOT=`dirname $0`
  export SAR_HELPERS_HOME=$_ROOT/../resources/lib 
  . $_ROOT/../resources/lib/sar-helpers.sh
  mkdir -p $_ROOT/runtime
  export _TEST=$_ROOT/runtime
}

tearDown() {
  [ -d $_TEST ] && rm -fr $_TEST
}

# load shunit2
. $SHUNIT2_HOME/shunit2
