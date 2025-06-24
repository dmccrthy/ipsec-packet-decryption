#!/bin/bash

##
# Imports IKE keys from specified file into wireshark
#
# Usage: 
#       ./import_ike.sh <file>
##

if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Clean the file of escape sequences and extract the keys
cleaned=$(sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' "$1" | grep '^Sk_')

# Extract each key using grep and cut
Sk_ei=$(echo "$cleaned" | grep '^Sk_ei' | cut -d ':' -f2- | xargs)
Sk_er=$(echo "$cleaned" | grep '^Sk_er' | cut -d ':' -f2- | xargs)
Sk_ai=$(echo "$cleaned" | grep '^Sk_ai' | cut -d ':' -f2- | xargs)
Sk_ar=$(echo "$cleaned" | grep '^Sk_ar' | cut -d ':' -f2- | xargs)

# Echo the keys
echo "Sk_ei: $Sk_ei"
echo "Sk_er: $Sk_er"
echo "Sk_ai: $Sk_ai"
echo "Sk_ar: $Sk_ar"