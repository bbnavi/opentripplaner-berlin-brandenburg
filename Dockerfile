# syntax=docker/dockerfile:1.2

ARG OTP_TAG=bbnavi-upstream
ARG OTP_IMAGE=docker.io/lehrenfried/opentripplanner

FROM $OTP_IMAGE:$OTP_TAG AS otp

ARG memory=30G
ENV MEMORY=$memory

WORKDIR /var/otp

ADD router-config.json /var/otp/
ADD build-config.json /var/otp/
ADD otp-config.json /var/otp/
ADD dgm/* /var/otp/

RUN java $JAVA_OPTS -cp @/app/jib-classpath-file @/app/jib-main-class-file /var/otp/ --build --save

ENV TZ="Europe/Berlin"
ENTRYPOINT java $JAVA_OPTS -cp @/app/jib-classpath-file @/app/jib-main-class-file /var/otp/ --load --serve
