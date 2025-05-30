#!/bin/bash

# USAGE:
#   ./tool.sh -d domain.com -o output.txt
#   ./tool.sh -l subdomains.txt -o output.txt

single_domain=""
list_file=""
output=""

while getopts "d:l:o:" opt; do
  case ${opt} in
    d ) single_domain=$OPTARG ;;
    l ) list_file=$OPTARG ;;
    o ) output=$OPTARG ;;
    \? ) echo "Usage: ./tool.sh -d domain.com | -l subdomains.txt -o output.txt" ; exit 1 ;;
  esac
done

# Validate input
if [[ -n "$single_domain" && -n "$list_file" ]] || [[ -z "$output" ]]; then
  echo "❌ Error: Use either -d for a single domain or -l for a list, not both."
  echo "✅ Usage: ./tool.sh -d domain.com -o output.txt"
  echo "       or ./tool.sh -l subdomains.txt -o output.txt"
  exit 1
fi

if [[ -n "$list_file" && ! -f "$list_file" ]]; then
  echo "❌ Error: File '$list_file' not found."
  exit 1
fi

# Define unwanted file extensions
EXT_PATTERN="\.(jpg|jpeg|png|gif|svg|css|ico|woff|woff2|ttf|eot|js|mp4|mp3|pdf|zip|gz|tar|exe|webp|bmp|avi|mov|doc|docx|xls|xlsx)(\?.*)?$"

# Create output file if not present
touch "$output"

run_scan_for_domain() {
  local domain="$1"
  local temp_file="/tmp/wayback_temp_$domain.txt"
  local filtered_file="/tmp/wayback_filtered_$domain.txt"

  > "$temp_file"
  > "$filtered_file"
  echo "[*] Running scan for $domain at $(date)"

  waybackurls "$domain" 2>/dev/null | grep "$domain" | \
    grep -Ev "$EXT_PATTERN" | sort -u > "$filtered_file"

  saved=0
  echo -ne "[+] $domain → Saved URLs: $saved\r"

  while read -r url; do
    if ! grep -Fxq "$url" "$output"; then
      echo "$url" >> "$output"
      ((saved++))
      echo -ne "[+] $domain → Saved URLs: $saved\r"
    fi
  done < "$filtered_file"

  echo -e "\n[✓] $domain → Scan complete. New URLs saved: $saved"
}

run_all_scans() {
  if [[ -n "$single_domain" ]]; then
    run_scan_for_domain "$single_domain"
  elif [[ -n "$list_file" ]]; then
    while read -r domain; do
      [[ -z "$domain" ]] && continue
      run_scan_for_domain "$domain"
    done < "$list_file"
  fi
}

# First run immediately
run_all_scans

# Loop every 24 hours
while true; do
  sleep 86400
  run_all_scans
done
