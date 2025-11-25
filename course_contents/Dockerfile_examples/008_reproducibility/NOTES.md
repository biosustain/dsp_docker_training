More info: https://docs.astral.sh/uv/guides/integration/docker/

Initialize project: `uv init --bare -p 3.14 --managed-python`
Add dependencies: `uv add numpy pandas`

The above creates the lock file `uv.lock`.

Use files .dockerignore and .gitignore to ensure files are not accidentally added
to your Docker images and git repos.

You might not want to use option `--bare`, in `uv init`.

You can handle Python installations with _uv_. See `uv python --help`.
