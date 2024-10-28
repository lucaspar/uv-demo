# `uv-demo` PyPI package

![PyPI - Version](https://img.shields.io/pypi/v/uv-demo)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/uv-demo)
![Pepy Total Downloads](https://img.shields.io/pepy/dt/uv-demo)
[![Action | Upload Python Package](https://github.com/lucaspar/uv-demo/actions/workflows/python-publish.yaml/badge.svg)](https://github.com/lucaspar/uv-demo/actions/workflows/python-publish.yaml)

A demo for the `uv` package manager. Very useless as a package.

Use this as a template for a `uv` package, with GitHub actions, pre-commit hooks, and some opinionated config.

## Quick start

This will install all dependencies (`uv sync`) and run the entrypoint script:

```bash
uv run uv-demo
```

## Make targets

```bash
make
# equivalent to make install tox

make install
# runs uv sync

make test
# runs tests for supported python versions

make serve-coverage
# serves coverage report on localhost:8000

make clean
# removes all venv, tox, cache, and generated files
```

## Integration with GitHub Actions

See the [Upload Python Package workflow file](.github/workflows/python-publish.yaml) for this package.

### Running actions locally

You can use `act` to run GitHub Actions locally. Use cases:

1. While writing a workflow, to test the workflow locally before pushing to the repository.
2. Run the publishing workflow without setting secrets on GitHub.
3. Before opening a pull request, to check the workflow will pass.

It can be installed as a GitHub CLI extension:

```bash
gh extension install https://github.com/nektos/gh-act
cp config/secrets.env.example config/secrets.env
# edit config/secrets.env with the required secrets
gh act --secret-file config/secrets.env
# select medium-sized image in first run.
```

+ [`act` installation](https://nektosact.com/installation/index.html)
+ [`act` usage](https://nektosact.com/usage/index.html)
