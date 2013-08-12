#!/bin/bash

gather() {
  local uname=`uname`

  case "$uname" in
    Darwin) local mem_stat=`top -l 1 | sed -En 's/PhysMem:.*[^0-9\.]+([0-9\.]+)M used, ([0-9\.]+)M free\./\1 \2/gp' | awk '{ total = $1 + $2; print "mem_used=" $1 ",mem_free=" $2 ",mem_total=" total; }'`
            local cpu_stat=`top -l 1 | sed -En 's/CPU usage:.*[^0-9\.]+([0-9\.]+)% idle/\1/gp' | awk '{ cpu_used = 100 - $1; print "cpu_used=" cpu_used ",cpu_free=" $1 }'`
            local disk_stat=`df -k . | sed -En 's/.*[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)%.*/\1 \2 \3 \4/gp' | awk '{ print "disk_total="$1/1024 ",disk_used="$2/1024 ",disk_free="$3/1024 }'`
            ;;
    Linux)  local mem_stat=`free -m | sed -rn 's/(Mem|Swap):[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*([0-9]+).*/\1 \2 \3 \4/gp' | awk '{ name = tolower($1); print name"_used="$3 ","name"_free="$4 ","name"_total="$2 }'`
            local cpu_stat=`mpstat | sed -rn 's/.*all.*[^0-9\.]+([0-9\.]+)[^0-9\.]+[0-9\.]+/\1/gp' | awk '{ cpu_used = 100 - $1; print "cpu_used=" cpu_used ",cpu_free=" $1 }'`
            local disk_stat=`df -k . | sed -rn 's/.*[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+)%.*/\1 \2 \3 \4/gp' | awk '{ print "disk_total="$1/1024 ",disk_used="$2/1024 ",disk_free="$3/1024 }'`
            ;;
  esac

  echo $cpu_stat","${mem_stat//$'\n'/,}","$disk_stat
}

gather
