
export _ROOT=$( pwd )
source ${_ROOT}/../resources/lib/sar-helpers.sh

testAdoreCreateEnv_different_missions() {
  master=$_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1
  slave=$_ROOT/../artifacts/ER02_SAR_RAW_0P_20100118T174929_20100118T174945_ESR_77106.CEOS.tar
  root=$( create_env_adore ${master} ${slave} ${_TEST} 2> /dev/null ) 
  res=$?
  assertEquals "Different missions must not be accepted" \
  "1" "$res" 
}

testAdoreCreateEnv_different_tracks() {
  # we know we passed L1 and L0, we saved some storage space by doing this
  master=$_ROOT/../artifacts/ASA_IM__0CNPDE20120329_071134_000000163113_00121_52721_6279.N1
  slave=$_ROOT/../artifacts/ASA_IM__0CNPDE20111031_071059_000000163108_00121_50566_4642.N1
  root=$( create_env_adore ${master} ${slave} ${_TEST} 2> /dev/null )
  res=$?
  assertEquals "Different tracks must not be accepted" \
  "1" "$res"
}

. ./common-tests.inc
