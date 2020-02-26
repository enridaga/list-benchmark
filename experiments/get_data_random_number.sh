#!/bin/bash
h=""
if [[ "$1" =~ ^1k ]]; then
	h=0657
elif [[ "$1" =~ ^30k ]]; then
	h=19432
elif [[ "$1" =~ ^60k ]]; then
	h=46789
elif [[ "$1" =~ ^90k ]]; then
	h=62987
elif [[ "$1" =~ ^120k ]]; then
	h=78234
fi

echo "$h"
