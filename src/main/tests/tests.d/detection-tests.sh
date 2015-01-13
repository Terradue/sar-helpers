#!/bin/bash

#
#
# detection
#
#

#sourcing required dir
source /root/sar-helpers/src/main/resources/lib/sar-helpers.sh

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

. ./common-tests.inc
