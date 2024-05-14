#!/bin/bash
# System info
hostname=$(hostname)
uptime=$(uptime -p)
cpu_usage=$(top -b -n1 | grep '%Cpu(s):' | awk '{print $2 + $4}')
ram_usage=$(free -m | grep Mem: | awk '{print $2}')
df_output=$(df -h | grep -vE '^Filesystem|tmpfs|udev')

# Sensors info
cpu_temp_file=/sys/class/thermal/thermal_zone0/temp
cpu_temp_c=$((cat $cpu_temp_file)/1000)

# Get thresholds from .conf
thresholds_file="system_thresholds.conf"
if [[ ! -f "$thresholds_file"]]; then
  echo "No thresholds file found ('$thresholds_file')"
  exit 1
fi
get_threshold() {
  key="$1"
  value=$(grep "^$key=" "$thresholds_file" | awk -F= '{print $2}')
  echo "$value"
}
cpu_warning=$(get_threshold "cpu_warning")
ram_warning=$(get_threshold "ram_warning")
disk_warning=$(get_threshold "disk_warning")

# Warnings
if [[ $cpu_usage -ge $cpu_warning ]]; then
  echo "WARNING: CPU usage is at $cpu_usage% (above threshold of $cpu_warning%)"
fi
if [[ $ram_usage -ge $ram_warning ]]; then
  echo "WARNING: RAM usage is at $ram_usage% (above threshold of $ram_warning%)"
fi
if [[ $ ]]
  echo 
fi
