.ONESHELL:

all: taiwan-latest.osm.pbf
	tilemaker --input taiwan-latest.osm.pbf \
		      --output output/ \
	          --config config.json \
	          --process process.lua

taiwan-latest.osm.pbf:
	curl -O http://download.geofabrik.de/asia/taiwan-latest.osm.pbf
