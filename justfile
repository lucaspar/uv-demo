# Justfile for uv-demo project
# https://cheatography.com/linux-china/cheat-sheets/justfile/

SHELL := x'/bin/bash'
DOCS_PORT := "12001"
DOC_FILES := '`find docs/ -type f`'

alias check:= pre-commit
alias update:= upgrade
alias gact-pr:= gact-pull-request

# Installs dependencies and runs tests
all: install test

# Build the package and run tests
build:
    uv build --no-cache

# Run all code quality checks and linting

# Clean up generated files
clean:
    @rm -rvf \
        '.tox' '.coverage' 'tests/htmlcov' '.ruff_cache' \
        '.pytest_cache' '.python-version' '.cache' 'dist' \
        '.venv' '.eggs' '.eggs/' \
        '*.egg-info' '*.egg-info/'

# Run deptry to check for unused and missing dependencies
deptry:
    uv run deptry .

# Generate and serve documentation
docs: docs-gen docs-serve

# Generate documentation using pdoc
docs-gen:
    uv run pdoc "src/uv_demo/" -o "docs/"
    @echo {{DOC_FILES}}
    uv run pre-commit run --files {{DOC_FILES}} || true
    @echo -e "\n\033[32mDocumentation generated in docs/ and linted with pre-commit hooks.\033[0m\n"

# Serve the docs with a simple HTTP server
docs-serve:
    uv run -m http.server {{DOCS_PORT}} -d "docs/" &> "/dev/null" & disown
    @sleep 1
    @xdg-open "http://localhost:{{DOCS_PORT}}/"

# Run the GitHub Actions workflow for all branches
gact:
    # install gh-act with:
    # gh extension install nektos/gh-act
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows"

# Run the GitHub Actions workflow for pull requests
gact-pull-request:
    # this will test the build and publish jobs, but the publish job will only
    # run successfully on the GitHub repo, as the configured trusted publisher.
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows" \
        --secret-file "config/secrets.env" \
        pull-request

# Run the GitHub Actions workflow for release
gact-release:
    gh act \
        --workflows "`git rev-parse --show-toplevel`/.github/workflows" \
        --secret-file "config/secrets.env" \
        release

# Install pre-commit hooks and development project dependencies with uv
install:
    uv run pre-commit install --install-hooks
    uv sync --dev --frozen

# Run pre-commit hooks on all files
pre-commit:
    uv run pre-commit run --all-files

# Build and publish the package to PyPI
publish:
    just build
    @if [ ! -f config/secrets.env ]; then \
        echo "Error: config/secrets.env does not exist."; \
        exit 1; \
    fi
    @export UV_PUBLISH_TOKEN=`/usr/bin/grep -E '^PYPI_API_TOKEN' "config/secrets.env" | cut -d '=' -f2`; uv publish

# Simple execution of tests with coverage
test:
    uv run pytest -vvv --cov="src"

# Run static checker and tests for all compatible python versions
test-all:
    just check
    @pyv=("3.11" "3.12" "3.13" "3.14"); \
    for py in "${pyv[@]}"; do \
        echo "${py}"; \
        uv run -p "${py}" pytest -v --cov="src"; \
    done

# Run tests with coverage and increased output
test-verbose:
    uv run pytest -vvv --cov="src" --capture=no

# Serve the coverage report with a simple HTTP server
serve-coverage:
    python -m http.server 8000 -d "tests/htmlcov"

# Upgrades all project and pre-commit dependencies respecting pyproject.toml constraints
upgrade:
    uv sync --upgrade
    uv run pre-commit autoupdate
