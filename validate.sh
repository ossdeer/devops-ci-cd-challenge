#!/bin/bash

set -e  # Exit if any command fails in a step
touch validation_output.txt

echo "🔍 DevOps Challenge Validation" > validation_output.txt
echo "==============================" >> validation_output.txt

# Accumulate status
ALL_OK=true

echo "[1/3] Checking /health endpoint..." | tee -a validation_output.txt
if curl -s --fail http://localhost:5000/health >> validation_output.txt; then
  echo "✅ /health endpoint is responsive." | tee -a validation_output.txt
else
  echo "❌ /health endpoint failed." | tee -a validation_output.txt
  ALL_OK=false
fi

echo -e "\n[2/3] Checking Docker container status..." | tee -a validation_output.txt
if docker ps | grep live-app >> validation_output.txt; then
  echo "✅ live-app container is running." | tee -a validation_output.txt
else
  echo "❌ live-app container is not running." | tee -a validation_output.txt
  ALL_OK=false
fi

echo -e "\n[3/3] Checking secret flag presence (server-side)..." | tee -a validation_output.txt
if [[ -f /opt/competition/flag.txt ]]; then
  echo "✅ Server-side flag is present and verified." | tee -a validation_output.txt
else
  echo "❌ Flag missing — validation failed." | tee -a validation_output.txt
  ALL_OK=false
fi

echo -e "\n==============================" >> validation_output.txt

if $ALL_OK; then
  echo "🎉 All validation checks passed!" | tee -a validation_output.txt
  exit 0
else
  echo "❌ One or more validation checks failed." | tee -a validation_output.txt
  exit 1
fi
