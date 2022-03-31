# Vollständiges Log

Um das vollständige Log sehen zu können muss die CLI erweiterung buildx verwendet werden:
(https://docs.docker.com/buildx/working-with-buildx/)

```
docker buildx create --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=1000000,env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 --use

docker buildx build .

docker build --tag registry.gitlab.tpwd.de/tpwd/bb-navi/opentripplaner-berlin-brandenburg:production -f Dockerfile .
docker login -u gitlab-ci-token -p [PERSONAL_ACCESS_TOKEN] registry.gitlab.tpwd.de
docker push registry.gitlab.tpwd.de/tpwd/bb-navi/opentripplaner-berlin-brandenburg:production
docker-compose -f docker-compose.yml -f stack.yml config > quantum.yml
quantum-cli stack update --create --stack otp-berlin-brandenburg-tpwd-bb-navi --wait
```

OSM ausschneiden:
https://docs.osmcode.org/osmium/latest/osmium-extract.html
https://github.com/mfdz/gtfs-hub/blob/16427530380765078981105c0201d69fd44117ac/makefile#L53
https://github.com/stadtnavi/digitransit-ansible/blob/master/roles/tilemaker/templates/build-mbtiles#L51
https://github.com/leonardehrenfried/otp2-setup/

# Traversal Permissions Map Layer im api.bbnavi.de
# OSM sind auch Fußwege (Braune Pfade im OTP)
# Bahnhöfe sind im GTFS (blaue Pfade im OTP)
