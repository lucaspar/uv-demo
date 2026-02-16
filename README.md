# `uv-demo` PyPI package

[![PyPI - Version](https://img.shields.io/pypi/v/uv-demo)](https://pypi.org/project/uv-demo/)
[![PyPI - Python Version](https://img.shields.io/pypi/pyversions/uv-demo)](https://pypi.org/project/uv-demo/)
[![Pepy Total Downloads](https://img.shields.io/pepy/dt/uv-demo)](https://pypi.org/project/uv-demo/)
[![Code Quality Check](https://github.com/lucaspar/uv-demo/actions/workflows/code-quality.yaml/badge.svg)](https://github.com/lucaspar/uv-demo/actions/workflows/code-quality.yaml)

A demo and template for a modern Python package managed by `uv`. Very useless as a
package.

Use this as a template for new projects, or as a reference for how to set up a Python
project with the following:

+ [x] `uv` as the Python package manager.
+ [x] [`pre-commit` hooks](./.pre-commit-config.yaml) for code formatting, linting, and
  quality checks.
+ [x] [GitHub Actions](./.github/workflows/) for testing and publishing.
+ [x] Multiple Python versions tested with `uv -p ${python-version} run pytest [...]`.
+ [x] `gh-act` for running GitHub Actions locally.
+ [x] [Justfile](./justfile) with common recipes.
+ [x] Documentation with `pdoc` + GitHub Pages.
+ [x] Deptry to highlight missing and unused dependencies.

## System Dependencies

+ `uv`
    + `curl -LsSf https://astral.sh/uv/install.sh | sh`
+ `just`
    + `sudo apt install just`
    + `sudo pacman -S just`
    + [More](https://github.com/casey/just#linux) installation methods.
+ For running GitHub Actions locally
    + [Docker](https://docs.docker.com/desktop/install/linux/)
    + `gh` (GitHub CLI)
        + `sudo pacman -S github-cli`
        + [Others](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)
    + [`gh-act`](https://github.com/nektos/gh-act)
        + `gh extension install nektos/gh-act`

## Quick start

This will install all dependencies (`uv sync`) and run the entrypoint script:

```bash
uv run uv-demo
```

## `just` Recipes

```bash
# just --list
Available recipes:
    list                      # List available recipes
    clean                     # Clean up generated files

    [dev]
    install                   # Install pre-commit hooks and development project dependencies with uv
    upgrade                   # Upgrade all project and pre-commit dependencies respecting pyproject.toml constraints [alias: update]
    pre-commit *args          # Run pre-commit hooks on all files; you may pass the hook ID: `just pre-commit pyrefly`` [alias: check]
    deptry                    # Run deptry to check for unused and missing dependencies

    [build]
    build                     # Build the package and run tests
    publish                   # Build and publish the package to PyPI

    [test]
    test *pytest_args         # Simple execution of tests with coverage
    test-lowest *pytest_args  # runs tests with the lowest compatible versions of dependencies, to check compatibility issues
    test-verbose *pytest_args # Run tests with coverage and increased output
    test-all                  # Run static checker and tests for all compatible python versions
    serve-coverage            # Serve the coverage report with a simple HTTP server

    [docs]
    docs                      # Generate and serve documentation
    docs-gen                  # Generate documentation using pdoc
    docs-serve                # Serve the docs with a simple HTTP server

    [ci]
    gact *args                # GH Actions workflow for all branches
    gact-pull-request         # GH Actions workflow with custom arguments. Example: `just gact -j qa-lint` to run only the linting job. [alias: gact-pr]
    gact-release              # GH Actions workflow for release
```

## Integration with GitHub Actions

See the [Upload Python Package workflow file](.github/workflows/python-publish.yaml) for
this package.

### Running actions locally

You can use `act` to run GitHub Actions locally. Use cases:

1. While writing a workflow, to test the workflow locally before pushing to the
   repository.
2. Run the publishing workflow without setting secrets on GitHub.
3. Before opening a pull request, to check the workflow will pass.

Copy the example secrets file:

```bash
cp "config/secrets.env.example" "config/secrets.env"
```

Then edit the new file to add your secrets.

After that, run `just gact --list` to see the available jobs.

```bash
just gact -j qa-lint
```

Or, run predefined workflows e.g. for pull requests:

```bash
just gact-pr
```
