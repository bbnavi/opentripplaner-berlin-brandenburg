ARG OTP_TAG=latest
ARG OTP_IMAGE=mfdz/opentripplanner

FROM $OTP_IMAGE:$OTP_TAG AS otp

# defined empty, so we can access the arg as env later again
ARG gtfs_url=https://www.vbb.de/fileadmin/user_upload/VBB/Dokumente/API-Datensaetze/GTFS.zip
ENV GTFS_URL=$gtfs_url
ARG osm_pbf_url=http://download.geofabrik.de/europe/germany/brandenburg-latest.osm.pbf
ENV OSM_PBF_URL=$osm_pbf_url
ARG memory=5G
ENV MEMORY=$memory

RUN apk add --update zip && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /opt/opentripplanner/build/

# add build data
# NOTE: we're using dockers caching here. Add items in order of least to most frequent changes
ADD router-config.json /opt/opentripplanner/build/
ADD build-config.json /opt/opentripplanner/build/
ADD otp-config.json /opt/opentripplanner/build/
ADD $OSM_PBF_URL /opt/opentripplanner/build/
ADD $GTFS_URL /opt/opentripplanner/build/gtfs.zip

# print version
RUN java -jar otp-shaded.jar --version | tee build/version.txt

# TODO: Auslagern in eigenen Step: build
RUN java -Xmx$MEMORY -jar otp-shaded.jar --build --save /opt/opentripplanner/build/ | tee build/build.log

#
ENTRYPOINT java -Xmx$MEMORY -jar otp-shaded.jar --load --serve /opt/opentripplanner/build/
