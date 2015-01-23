#!/bin/bash

#
#
# GMTSAR
#
#

export _ROOT=$( pwd )
source ${_ROOT}/../resources/lib/sar-helpers.sh

testLinkASAR_gmtsar() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1 $_TEST/raw`
  res=$?
  assertEquals "link ASAR GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_tar() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tar $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tar GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_zip() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.zip $_TEST/raw`
  res=$?
  assertEquals "extract ASAR zip GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_gz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.gz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR gz GMTSAR failed" \
  "0" "$res"
}

testLinkASAR_gmtsar_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_N1E1E2_gmtsar $_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ASAR tgz GMTSAR failed" \
  "0" "$res"
}

testLinkERSCEOS_gmtsar_tgz() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_gmtsar $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tgz $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tgz GMTSAR failed" \
  "0" "$res"
}

testLinkERSCEOS_gmtsar_tar() {
  mkdir -p $_TEST/raw
  out=`__link_ERSCEOS_gmtsar $_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar $_TEST/raw`
  res=$?
  assertEquals "extract ERS CEOS tar GMTSAR failed" \
  "0" "$res"
  find $_TEST
}

testCreate_env_gmtsar_ASAR() {
  mkdir -p $_TEST
  master="$_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1.tgz"
  slave="$_ROOT/../artifacts/ASA_IM__0CNPDE20111031_071059_000000163108_00121_50566_4642.N1"
  create_env_gmtsar $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ASAR" \
  "0" "$res"
}

testCreate_env_gmtsar_ERSCEOS() {
  mkdir -p $_TEST
  master="$_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar.gz"
  slave="$_ROOT/../artifacts/ER02_SAR_RAW_0P_20060807T174703_20060807T174719_ESR_59070.CEOS.tgz"
  create_env_gmtsar $master $slave $_TEST
  res=$?
  assertEquals "create GMTSAR env with ERS CEOS" \
  "0" "$res"
  find $_TEST
}

. ./common-tests.inc
