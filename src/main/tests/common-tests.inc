setUp() {
  # load include to test
  export _ROOT=`dirname $0`
  mkdir -p $_ROOT/runtime
  export _TEST=$_ROOT/runtime
}

tearDown() {
  [ -d $_TEST ] && rm -fr $_TEST
}

# load shunit2
. $SHUNIT2_HOME/shunit2
