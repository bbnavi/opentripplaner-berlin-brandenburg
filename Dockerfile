# syntax=docker/dockerfile:1.2

ARG OTP_TAG=2022-09-01-12_19
ARG OTP_IMAGE=mfdz/opentripplanner

FROM $OTP_IMAGE:$OTP_TAG AS otp

# defined empty, so we can access the arg as env later again

# GTFS Daten vom VBB
ARG gtfs_url=https://www.vbb.de/fileadmin/user_upload/VBB/Dokumente/API-Datensaetze/gtfs-mastscharf/GTFS.zip
ENV GTFS_URL=$gtfs_url

# GTFS Daten von fahrgemeinschaft mifaz
ARG gtfs_carpool_feed_url=https://amarillo.bbnavi.de/gtfs/amarillo.bb.gtfs.zip
ENV GTFS_CARPOOL_FEED_URL=$gtfs_carpool_feed_url

# GTFS Daten von FlexFeed derhuerst
ARG gtfs_flexfeed_url=https://opendata.bbnavi.de/vbb-gtfs-flex/gtfs-flex.zip
ENV GTFS_FLEXFEED_URL=$gtfs_flexfeed_url

# OSM Tool zum erstellen von eigenen OSM Daten: Osmium
ARG osm_pbf_url=https://gtfs.mfdz.de/bb-buffered.osm.pbf
ENV OSM_PBF_URL=$osm_pbf_url

ARG memory=30G
ENV MEMORY=$memory

RUN mkdir -p /opt/opentripplanner/build/

# add build data
# NOTE: we're using dockers caching here. Add items in order of least to most frequent changes
ADD router-config.json /opt/opentripplanner/build/
ADD build-config.json /opt/opentripplanner/build/
ADD otp-config.json /opt/opentripplanner/build/
ADD $OSM_PBF_URL /opt/opentripplanner/build/
ADD $GTFS_URL /opt/opentripplanner/build/gtfs.zip
ADD $GTFS_FLEXFEED_URL /opt/opentripplanner/build/
ADD $GTFS_CARPOOL_FEED_URL /opt/opentripplanner/build/gtfs-carpool.gtfs.zip
ADD dgm/* /opt/opentripplanner/build/

# print version
RUN java -jar otp-shaded.jar --version | tee build/version.txt

RUN java -Xmx$MEMORY -jar otp-shaded.jar --build --save /opt/opentripplanner/build/ | tee build/build.log

ENV TZ="Europe/Berlin"
#
ENTRYPOINT java -Xmx$MEMORY -jar otp-shaded.jar --load --serve /opt/opentripplanner/build/
