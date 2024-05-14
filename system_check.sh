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
cpu_tempc_warning=$(get_threshold "cpu_tempc_warning")
ram_warning=$(get_threshold "ram_warning")
disk_warning=$(get_threshold "disk_warning")

# Warnings
if [[ $cpu_usage -ge $cpu_warning ]]; then
  echo "WARNING: CPU usage is at $cpu_usage% (above threshold of $cpu_warning%)" >> system_warnings.txt
fi
if [[ $cpu_temp_c -ge $cpu_tempc_warning ]]; then
  echo "WARNING: CPU temperature is at $cpu_temp_c C (above threshold of $cpu_tempc_warning C)" >> system_warnings.txt
fi
if [[ $ram_usage -ge $ram_warning ]]; then
  echo "WARNING: RAM usage is at $ram_usage% (above threshold of $ram_warning%)" >> system_warnings.txt
fi
for line in $df_output; do
  percent_used=$(echo $line | awk '{print $5}')
  if [[ $percent_used -ge $disk_warning ]]; then
    mount_point=$(echo $line | awk '{print $6}')
    echo "WARNING: Disk usage on $mount_point is at $percent_used% (above threshold of $disk_warning%)" >> system_warnings.txt
  fi
done

# General output
echo "Hostname: $hostname" >> system_health.txt
echo "Uptime: $uptime" >> system_health.txt
echo "CPU Usage: $cpu_usage%" >> system_health.txt
echo "CPU Temperature: $cpu_temp_c C" >> system_health.txt
echo "RAM Usage: $ram_usage%" >> system_health.txt
echo "Disk Usage: $df_output" >> system_health.txt