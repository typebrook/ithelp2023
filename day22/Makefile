.ONESHELL:

tiles: taiwan-latest.osm.pbf
	tilemaker \
		--input $< \
		--output $@

test.mbtiles: taiwan-latest.osm.pbf
	tilemaker \
		--input $< \
		--output $@

taiwan-latest.osm.pbf:
	curl -O http://download.geofabrik.de/asia/taiwan-latest.osm.pbf

clean:
	rm -rf tiles

