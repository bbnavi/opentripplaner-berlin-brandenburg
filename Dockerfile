FROM mfdz/opentripplanner:2022-03-28-13_44 AS otp

# defined empty, so we can access the arg as env later again

# GTFS der VBB
ARG gtfs_url=http://vbb.de/vbbgtfs

# GTFS Daten von delfi (#BBNAV-71)
# ARG gtfs_url=https://gtfs.mfdz.de/DELFI.BB.gtfs.zip
ENV GTFS_URL=$gtfs_url

# GTFS Daten von FlexFeed derhuerst
ARG gtfs_flexfeed_url=https://github.com/bbnavi/gtfs-flex/releases/download/2022-03-10/gtfs-flex.zip
ENV GTFS_FLEXFEED_URL=$gtfs_flexfeed_url

# OSM Tool zum erstellen von eigenen OSM Daten: Osmium
# ARG osm_pbf_url=http://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf
ARG osm_pbf_url=https://gtfs.mfdz.de/bb-buffered.osm.pbf
ENV OSM_PBF_URL=$osm_pbf_url

ARG memory=30G
ENV MEMORY=$memory

RUN mkdir -p /opt/opentripplanner/build/

# add build data
# NOTE: we're using dockers caching here. Add items in order of least to most frequent changes
ADD dgm/* /opt/opentripplanner/build/
ADD $GTFS_FLEXFEED_URL /opt/opentripplanner/build/
ADD router-config.json /opt/opentripplanner/build/
ADD build-config.json /opt/opentripplanner/build/
ADD otp-config.json /opt/opentripplanner/build/
ADD $OSM_PBF_URL /opt/opentripplanner/build/
ADD $GTFS_URL /opt/opentripplanner/build/gtfs.zip

# GTFS Daten von fahrgemeinschaft mifaz
# URL ist hinterlegt in GITHUB Secrets: GTFS_CARPOOL_URL
RUN --mount=type=secret,id=GTFS_CARPOOL_URL export GTFS_CARPOOL_URL=$(cat /run/secrets/GTFS_CARPOOL_URL) && curl -LJO -o /opt/opentripplanner/build/gtfs-carpool.zip $GTFS_CARPOOL_URL

# print version
RUN java -jar otp-shaded.jar --version | tee build/version.txt

RUN java -Xmx$MEMORY -jar otp-shaded.jar --build --save /opt/opentripplanner/build/ | tee build/build.log

#
ENTRYPOINT java -Xmx$MEMORY -jar otp-shaded.jar --load --serve /opt/opentripplanner/build/
