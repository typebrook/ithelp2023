.ONESHELL:

tiles: taiwan-latest.osm.pbf
	tilemaker \
		--input $< \
		--output $@/ \
		--config config-openmaptiles.json \
		--process process-openmaptiles.lua

taiwan-latest.osm.pbf:
	curl -O http://download.geofabrik.de/asia/taiwan-latest.osm.pbf

clean:
	rm -rf $<
