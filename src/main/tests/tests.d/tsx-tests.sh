#!/bin/bash

#
#
# TSX TerraSAR-X
#
#

export _ROOT=$( pwd )
source ${_ROOT}/../resources/lib/sar-helpers.sh

testGetTSX_sensing_date() {
  out=$( __get_TSX_sensing_date "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract sensing date from TerraSAR-X" \
  "20140212" "$out"
}

testGetTSX_mission() {
  out=$( __get_TSX_mission "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract mission from TerraSAR-X" \
  "TDX" "$out"
}

testGetTSX_track() {
  out=$( __get_TSX_track "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract track from TerraSAR-X" \
  "55" "$out"
}

testGetTSX_cycle() {
  out=$( __get_TSX_cycle "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract cycle from TerraSAR-X" \
  "222" "$out"
}

testGetTSX_direction() {
  out=$( __get_TSX_direction "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract direction from TerraSAR-X" \
  "ASCENDING" "$out"
}

testGetTSX_orbit() {
  out=$( __get_TSX_orbit "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to extract absolute orbit from TerraSAR-X" \
  "20232" "$out"
}

testIsTSX() {
  out=$( __is_TSX "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz" )
  res=$?
  assertEquals "Failed to detect TSX" \
  "0" "$res"
}

testGetSensingdate_TSX() {
  out=`get_sensing_date "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz"`
  assertEquals "Failed to retrieve TSX sensing date" \
  "20140212" "$out"
}

testGetTrack_TSX() {
  out=`get_track "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz"`
  assertEquals "Failed to retrieve TSX track" \
  "55" "$out"
}

testGetDirection_TSX() {
  out=`get_direction "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz"`
  assertEquals "Failed to retrieve TSX orbit direction" \
  "ASCENDING" "$out"
}

testGetCycle_TSX() {
  out=`get_cycle "$_ROOT/../artifacts/TSX_20140212T164857.921_Etna_C222_O055_A_R_SM006_SSC.tar.gz"`
  assertEquals "Failed to retrieve TSX orbit direction" \
  "222" "$out"
}

. ./common-tests.inc
