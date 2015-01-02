#!/bin/bash

testDirectory() {
  out=`get_MIMEtype $(dirname $0)`
  assertEquals "Failed on directory MIME type" \
  "directory" $out
}

setUp() {
  # load include to test
  . `dirname $0`/../resources/scripts/sar-helpers
}

# load shunit2
. $SHUNIT2_HOME/src/shunit2
