#!/bin/sh

hora="$(date +"%H")"

if [ "$hora" -ge 10 ] && [ "$hora" -lt 18 ]; then
	feh --bg-fill ~/Pictures/pawel-czerwinski-aYrloxA3PrI-unsplash.jpg
else
    feh --bg-fill ~/Pictures/pawel-czerwinski-aYrloxA3PrI-unsplash.jpg
fi
