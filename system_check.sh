#!/bin/bash
# System info
hostname=$(hostname)
uptime=$(uptime -p)
loadavg=$(uptime | awk '{print $NF}')
cpu_usage=$(top -b -n1 | grep '%Cpu(s):' | awk '{print $2 + $4}')
free_ram=$(free -m | grep Mem: | awk '{print $4}')
total_ram=$(free -m | grep Mem: | awk '{print $2}')
df_output=$(df -h | grep -vE '^Filesystem|tmpfs|udev')

# Sensors info
CPU_TEMP_FILE=/sys/class/thermal/thermal_zone0/temp
CPU_TEMP_O=$(cat $CPU_TEMP_FILE)
CPU_TEMP_C=$((CPU_TEMP_O/1000))
CPU_TEMP_F=$(($CPU_TEMP_C * 9/5 + 32))

# CPU
if [[ $cpu_usage -ge $CPU_WARNING ]]; then
  
#   echo "WARNING: CPU usage is at $cpu_usage% (above threshold of $CPU_WARNING%)"
fi