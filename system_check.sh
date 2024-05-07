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

# Thresholds (defined as % of use)
CPU_WARNING=80
RAM_WARNING=80
DISK_WARNING=90

# Warning logic


# Display info
echo "Hostname: $hostname"
echo "Uptime: $uptime"
echo "Load Average: $loadavg"
echo "CPU Usage: $cpu_usage%"
echo "RAM Usage: $ram_usage%"
echo "Disk Usage: $df_output"

echo "CPU Temperature: $CPU_TEMP_C C / $CPU_TEMP_F F"