#!/bin/bash

redbase="$1"


base=$(echo "$redbase" | cut -d '.' -f1-3 )

echo "$base"

for i in {1..255}; do

	
	if ping -q -c 2 -W 1 "$base"."$i" &> /dev/null; then
		echo "Host Activo: $base.$i "
	fi
done
