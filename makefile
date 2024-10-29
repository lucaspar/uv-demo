# Title: Makefile for uv-demo project

SHELL=/bin/bash

all: install test

# SETUP
install:
	uv run pre-commit install --install-hooks
	uv sync --dev --frozen

# GITHUB ACTIONS
gact:
	# install gh-act with:
	# gh extension install nektos/gh-act
	gh act --workflows .github/workflows --secret-file config/secrets.env

# TESTS
test: tox
tox:
	# pyv=("3.11" "3.12" "3.13"); for py in "${pyv[@]}"; do echo "${py}"; uv run -p "${py}" tox run -vvv -e "python${py}"; done
	uv run -p "3.11" tox run -e "python3.11"
	uv run -p "3.12" tox run -e "python3.12"
	uv run -p "3.13" tox run -e "python3.13"

serve-coverage:
	python -m http.server 8000 -d tests/htmlcov

# CLEANUP
clean:
	rm -rf \
		.tox .coverage \
		.pytest_cache .python-version .cache dist \
		.venv .eggs .eggs/ \
		*.egg-info *.egg-info/

# UPDATE
update:
	uv sync --upgrade
	uv run pre-commit autoupdate
