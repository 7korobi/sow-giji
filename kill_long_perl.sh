#! /bin/sh
for roop in  5 10 15 20 25 30 35 40 45 50 55 60
do
  ps -A | grep "^...........RN.......1......*perl.sow" | cut -c 1-5 | xargs kill
  sleep 5
done
