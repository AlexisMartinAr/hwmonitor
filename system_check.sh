#!/bin/bash
# System info
hostname=$(hostname)
uptime=$(uptime -p)
cpu_usage=$(top -b -n1 | grep '%Cpu(s):' | awk '{print $2 + $4}')
ram_usage=$(free -m | grep Mem: | awk '{print $2}')
df_output=$(df -h | grep -vE '^Filesystem|tmpfs|udev')

# Sensors info
CPU_TEMP_FILE=/sys/class/thermal/thermal_zone0/temp
CPU_TEMP_C=$((cat $CPU_TEMP_FILE)/1000)

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

# Warnings
if [[ $cpu_usage -ge $CPU_WARNING ]]; then
  echo "WARNING: CPU usage is at $cpu_usage% (above threshold of $CPU_WARNING%)"
fi
if [[ $ram_usage -ge $RAM_WARNING ]]; then
  echo "WARNING: RAM usage is at $ram_usage% (above threshold of $RAM_WARNING%)"
fi
if [[ $ ]]
  echo 
fi
