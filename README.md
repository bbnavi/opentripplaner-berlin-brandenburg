# Vollständiges Log

Um das vollständige Log sehen zu können muss die CLI erweiterung buildx verwendet werden:
(https://docs.docker.com/buildx/working-with-buildx/)

```
docker buildx create --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=1000000,env.BUILDKIT_STEP_LOG_MAX_SPEED=100000000 --use

docker buildx build .
```
