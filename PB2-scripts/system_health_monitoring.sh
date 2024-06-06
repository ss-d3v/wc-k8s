#!/bin/bash

# Defining threshold values
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Logs file
LOG_FILE="system_health.log"

# Get current CPU usage
CPU_USAGE=$(vmstat 1 2 | awk 'END { print 100 - $15 }')

# Get Memory usage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

# Get Disk usage
DISK_USAGE=$(df --total -hl | tail -n1 | awk '{ print $5 }' | cut -d'%' -f1)

echo "---------------------------------------------$(date)---------------------------------------------" | tee -a "$LOG_FILE"

# Alert if thresholds are exceeded
if [ $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc) -ne 0 ]; then
  echo "ALERT: CPU Usage is high - ${CPU_USAGE}%" | tee -a "$LOG_FILE"
fi

if [ $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc) -ne 0 ]; then
  echo "ALERT: Memory Usage is high - ${MEM_USAGE}%" | tee -a "$LOG_FILE"
fi

if [ $(echo "$DISK_USAGE > $DISK_THRESHOLD" | bc) -ne 0 ]; then
  echo "ALERT: Disk Usage is high - ${DISK_USAGE}%" | tee -a "$LOG_FILE"
fi

# Top 10 processes by memory usage
echo ""
echo "Top 10 running processes by memory usage:" | tee -a "$LOG_FILE"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 11 | tee -a "$LOG_FILE"