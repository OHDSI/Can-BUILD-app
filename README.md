# Can-BUILD-app

Docker build of the Can-BUILD results viewer (Shiny), deployed through [ShinyProxyDeploy](https://github.com/OHDSI/ShinyProxyDeploy).

## Configuration

Set at runtime, never in the image. For local testing put them in a git-ignored `.env`:

```
OHDSI_RESULTS_DATABASE_SERVER=host/database
OHDSI_RESULTS_DATABASE_USER=read_only_user
OHDSI_RESULTS_DATABASE_PASSWORD=...
RESULT_DATABASE_SCHEMA=can_build_results   # optional, this is the default
```

Use a read-only database user.

## Build and publish

Publishing a GitHub release (tag `vX.Y.Z`) or running the workflow manually pushes `ohdsi/can-build-app:X.Y.Z` to Docker Hub. The repository needs the `DOCKER_HUB_USERNAME` and `DOCKER_HUB_ACCESS_TOKEN` secrets.
