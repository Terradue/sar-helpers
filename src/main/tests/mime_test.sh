#!/bin/bash

testDirectory() {
  out=`get_MIMEtype $(dirname $0)`
  assertEquals "Failed on directory MIME type" \
  "application/x-directory; charset=binary" "$out"
}


testEnvisatMIME() {
  out=`get_MIMEtype $(dirname $0)/artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1`
  assertEquals "Failed to retrieve Envisat MIME type" \
  "application/octet-stream; charset=binary" "$out"
}

setUp() {
  # load include to test
  . `dirname $0`/../resources/scripts/sar-helpers
}

# load shunit2
. $SHUNIT2_HOME/src/shunit2
