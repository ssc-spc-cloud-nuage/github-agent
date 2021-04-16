# GitHub Runner
Ubuntu 20.04 Docker image with the latest GitHub runner and some supporting tools from the [official VM image](https://github.com/actions/virtual-environments).

# Run with docker-compose

Create a `.env` file with the following:

```sh
RUNNER_NAME=github-runner
RUNNER_REPO_URL=https://github.com/org-name/repo-name   # Runner for a repo; or
# RUNNER_ORG_URL=https://github.com/org-name            # Runner for an organization
GITHUB_TOKEN=GitHub-PAT                                 # Personal access token with either "repo" or "admin:org" scope
                                                        # Note: token must be for an admin user for the repo or org
```

If you use Docker actions in your workflow: 

1. create a `/home/runner/_work` directory (optional as docker-compose will create it if missing in most cases...); and
2. uncomment the volume mount in docker-compose.yaml.  

This volume will be used to share the checked out repo with the Docker actions.   

Finally, run with:

```sh
make compose
```

# Build image locally

```sh
make build
```

Once the build is finished, you can debug with:

```sh
make shell
```

# Credit
* Tool install scripts from [actions/virtual-environments](https://github.com/actions/virtual-environments/tree/main/images/linux/scripts)
* Configuration from [tcardonne/docker-github-runner](https://github.com/tcardonne/docker-github-runner)
