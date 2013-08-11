#!/bin/bash

UNAME=`uname`

case "$UNAME" in
  Darwin) MEM_STAT=`top -l 1 | sed -En 's/PhysMem:.*[^0-9\.]+([0-9\.]+)M used, ([0-9\.]+)M free\./\1 \2/gp' | awk '{ total = $1 + $2; print "mem_used=" $1 ",mem_free=" $2 ",mem_total=" total; }'`
          CPU_STAT=`top -l 1 | sed -En 's/CPU usage:.*[^0-9\.]+([0-9\.]+)% idle/\1/gp' | awk '{ cpu_used = 100 - $1; print "cpu_used=" cpu_used ",cpu_free=" $1 }'`
          ;;
  Linux)  MEM_STAT=`free -m | sed -rn 's/(Mem|Swap):[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*([0-9]+).*/\1 \2 \3 \4/gp' | awk '{ name = tolower($1); print name"_used="$3 ","name"_free="$4 ","name"_total="$2 }'`
          CPU_STAT=`mpstat | sed -rn 's/.*all.*[^0-9\.]+([0-9\.]+)[^0-9\.]+[0-9\.]+/\1/gp' | awk '{ cpu_used = 100 - $1; print "cpu_used=" cpu_used ",cpu_free=" $1 }'`
          ;;
esac

echo $CPU_STAT","${MEM_STAT//$'\n'/,}

