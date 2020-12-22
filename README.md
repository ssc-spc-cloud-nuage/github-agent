# GitHub Runner
A Ubuntu 20.04 Docker image with the latest GitHub runner and some supporting tools from the [official VM images](https://github.com/actions/virtual-environments).

# Using docker-compose.yml

Create a `.env` file with the following:

```sh
RUNNER_NAME=github-runner
REPO_OWNER=repo-owner       # https://github.com/repo-owner
REPO_NAME=repo-name         # https://github.com/repo-owner/repo-name
GITHUB_TOKEN=GitHub-Personal-Access-Token
```

And run with:

```sh
docker-compose up -d
```

# Credit
* Tool install scripts from [actions/virtual-environments](https://github.com/actions/virtual-environments/tree/main/images/linux/scripts).
* Configuration from [tcardonne/docker-github-runner](https://github.com/tcardonne/docker-github-runner)
