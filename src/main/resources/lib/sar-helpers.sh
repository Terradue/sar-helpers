#!/bin/bash

set -o pipefail

[ ! -z "${SAR_HELPERS_HOME}" ] && {
  source "${SAR_HELPERS_HOME}/exec.d/ERS.sh"
  source "${SAR_HELPERS_HOME}/exec.d/Envisat.sh"
  source "${SAR_HELPERS_HOME}/exec.d/adore.sh"
  source "${SAR_HELPERS_HOME}/exec.d/common.sh"
  source "${SAR_HELPERS_HOME}/exec.d/gmtsar.sh"
  source "${SAR_HELPERS_HOME}/exec.d/roipac.sh"
  source "${SAR_HELPERS_HOME}/exec.d/public.sh"
  source "${SAR_HELPERS_HOME}/exec.d/tsx.sh"
} || {
	echo "[$( date +'%Y-%m-%dT%H:%M:%S%z' )]: Please make sure the SAR_HELPERS_HOME variable is defined" > /dev/stderr
}
