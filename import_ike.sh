#!/bin/bash

##
# Imports IKEv2 keys from specified file into Wireshark.
# This will handle decryption of the initial IKE exchange.
##

ike_table=~/.config/wireshark/ikev2_decryption_table

# Catch error if ike_table does not exist
if [ ! -f $ike_table ]; then
  echo "Error: IKEv2 Decryption Table not found"
  exit 1
fi

cat $ike_table

# Catch error for missing filename
if [ -z "$1" ]; then
  echo "Usage: $0 <file-path>"
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

# Load into wireshark (this defaults to ~/.config/wireshark)
echo ", ,$Sk_ei,$Sk_er, ,$Sk_ai,$Sk_ar,\"\"" >> $ike_table
