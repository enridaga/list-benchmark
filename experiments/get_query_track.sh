#!/bin/bash
h=""
if [[ "$1" =~ ^1k ]]; then
	h=8cf9897535d79e68c33a3076aa06d073
elif [[ "$1" =~ ^30k ]]; then
	h=2473e18eec6cc55b82c5dddab3bea353
elif [[ "$1" =~ ^60k ]]; then
	h=b77cd0a13a67bba8797d39a4e6ccd0d3
elif [[ "$1" =~ ^90k ]]; then
	h=067dffc37b3770b4f1c246cc7023b64d
elif [[ "$1" =~ ^120k ]]; then
	h=c45ada306052e9b8cd0a377c42679f8e
fi

echo "http://purl.org/midi-ld/piece/$h/track00"
