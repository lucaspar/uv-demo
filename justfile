# Justfile for uv-demo project
# https://cheatography.com/linux-china/cheat-sheets/justfile/

SHELL := x'/bin/bash'
DOC_FILES := '`find docs/ -type f`'
PORT_COVERAGE := "12002"
PORT_DOCS := "12001"
SUPPORTED_PYTHON_VERSIONS := "3.11 3.12 3.13 3.14"
PRE_COMMIT_DEFAULT_ARGS := "--all-files"

alias check := pre-commit
alias update := upgrade
alias gact-pr := gact-pull-request

# List available recipes
[default]
list:
    @just --list --unsorted

# Install pre-commit hooks and development project dependencies with uv
[group('dev')]
install:
    uv run pre-commit install --install-hooks
    uv sync --dev --frozen

# Upgrade all project and pre-commit dependencies respecting pyproject.toml constraints
[group('dev')]
upgrade:
    uv sync --upgrade
    uv run pre-commit autoupdate

# Run pre-commit hooks on all files; you may pass the hook ID: `just pre-commit pyrefly``
[group('dev')]
pre-commit *args:
    uv run pre-commit run {{ PRE_COMMIT_DEFAULT_ARGS }} {{ args }}

# Run deptry to check for unused and missing dependencies
[group('dev')]
deptry:
    uv run deptry .

# Build the package and run tests
[group('build')]
build:
    uv build --no-cache

# Build and publish the package to PyPI
[group('build')]
publish:
    just build
    @if [ ! -f config/secrets.env ]; then \
        echo "Error: config/secrets.env does not exist."; \
        exit 1; \
    fi
    @export UV_PUBLISH_TOKEN=`/usr/bin/grep -E '^PYPI_API_TOKEN' "config/secrets.env" | cut -d '=' -f2`; uv publish

# Simple execution of tests with coverage
[group('test')]
test *pytest_args:
    uv run --resolution highest pytest -vvv \
        --cov="src" \
        --cov-fail-under=75 \
        --no-cov-on-fail \
        {{ pytest_args }}

# runs tests with the lowest compatible versions of dependencies, to check compatibility issues
[group('test')]
test-lowest *pytest_args:
    uv run --resolution lowest-direct pytest -vvv \
        {{ pytest_args }}
    # reset lock file
    uv lock --quiet --resolution highest

# Run tests with coverage and increased output
[group('test')]
test-verbose *pytest_args:
    uv run pytest -vvv --cov="src" --capture=no {{ pytest_args }}

# Run static checker and tests for all compatible python versions
[group('test')]
test-all:
    @pyv=({{ SUPPORTED_PYTHON_VERSIONS }}); \
    for py in "${pyv[@]}"; do \
        echo "${py}"; \
        uv run -p "${py}" pytest -v --cov="src"; \
    done

# Serve the coverage report with a simple HTTP server
[group('test')]
serve-coverage:
    python -m http.server {{ PORT_COVERAGE }} -d "tests/htmlcov"

# Generate and serve documentation
[group('docs')]
docs: docs-gen docs-serve

# Generate documentation using pdoc
[group('docs')]
docs-gen:
    uv run pdoc "src/uv_demo/" -o "docs/"
    @echo {{ DOC_FILES }}
    uv run pre-commit run --files {{ DOC_FILES }} || true
    @echo -e "\n\033[32mDocumentation generated in docs/ and linted with pre-commit hooks.\033[0m\n"

# Serve the docs with a simple HTTP server
[group('docs')]
docs-serve:
    @sleep 1 && xdg-open "http://localhost:{{ PORT_DOCS }}/" &
    uv run -m http.server {{ PORT_DOCS }} -d "docs/"

# GH Actions workflow with custom arguments. Example: `just gact -j qa-lint` to run only the linting job.
[group('ci')]
gact *args:
    # install gh-act with:
    # gh extension install nektos/gh-act
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows" \
        {{ args }}

# GH Actions workflow for pull requests, featuring QA jobs.
[group('ci')]
gact-pull-request:
    # this will test the build and publish jobs, but the publish job will only
    # run successfully on the GitHub repo, as the configured trusted publisher.
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows" \
        --secret-file "config/secrets.env" \
        pull_request

# GH Actions workflow for release
[group('ci')]
gact-release:
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows" \
        --secret-file "config/secrets.env" \
        release

# Clean up generated files
clean:
    @rm -rvf \
        '.tox' '.coverage' 'tests/htmlcov' '.ruff_cache' \
        '.pytest_cache' '.python-version' '.cache' 'dist' \
        '.venv' '.eggs' '.eggs/' \
        '*.egg-info' '*.egg-info/'
