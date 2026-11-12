# Can-BUILD-app

Docker build of the Can-BUILD results viewer (Shiny), deployed through [ShinyProxyDeploy](https://github.com/OHDSI/ShinyProxyDeploy).

## Configuration

Set at runtime, never in the image. For local testing put them in a git-ignored `.env`:

```
shinydbServer=host
shinydbDatabase=database
shinydbPort=5432
shinydbPw=...
```

The database user is fixed to `shinyproxy` (read-only).

## Build and publish

Publishing a GitHub release (tag `vX.Y.Z`) or running the workflow manually pushes `ohdsi/can-build-app:X.Y.Z` to Docker Hub. The repository needs the `DOCKER_HUB_USERNAME` and `DOCKER_HUB_ACCESS_TOKEN` secrets.
