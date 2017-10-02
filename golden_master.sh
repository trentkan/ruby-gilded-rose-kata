#!/bin/bash
for iteration in {0..16}
do
  ruby texttest_fixture.rb  "$iteration" > spec/temp_files/day_"$iteration".txt
  if [ "$1" == "--override" ]; then
    cp spec/temp_files/day_"$iteration".txt spec/master_files/day_"$iteration".txt
  fi

  DIFF=$(diff spec/temp_files/day_"$iteration".txt spec/master_files/day_"$iteration".txt)

  if [ "$DIFF" != "" ]
  then
    echo Failed iteration "$iteration"
    diff spec/temp_files/day_"$iteration".txt spec/master_files/day_"$iteration".txt
  else
    echo Passed iteration "$iteration"
  fi
  echo
  echo
done
