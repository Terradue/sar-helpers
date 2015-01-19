#!/bin/bash

#run each test packages
for mytest in $( ls tests.d/*-tests.sh )
do
  echo "****************************************"
  echo "*                                      *"
  echo "*          ${mytest}                                  " | cut -c 1-39 | tr -d '\n'; echo "*"
  echo "*                                      *"
  echo "****************************************"
  
  ./${mytest}
 
#  [ $? -ne 0 ] && exit 1

  echo

done

