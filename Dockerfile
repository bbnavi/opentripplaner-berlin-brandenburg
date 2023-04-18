# syntax=docker/dockerfile:1.2

ARG OTP_TAG=2.3.0_2023-04-18T07-09
ARG OTP_IMAGE=docker.io/opentripplanner/opentripplanner

FROM $OTP_IMAGE:$OTP_TAG AS otp

WORKDIR /var/otp

ADD router-config.json /var/otp/
ADD build-config.json /var/otp/
ADD otp-config.json /var/otp/
ADD dgm/* /var/otp/

ENV JAVA_OPTS="-Xmx30G -Dotp.logging.format=json"
RUN java $JAVA_OPTS -cp @/app/jib-classpath-file @/app/jib-main-class-file /var/otp/ --build --save

ENV TZ="Europe/Berlin"
ENTRYPOINT java $JAVA_OPTS -cp @/app/jib-classpath-file @/app/jib-main-class-file /var/otp/ --load --serve
