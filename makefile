# Title: Makefile for uv-demo project

SHELL=/bin/bash

all: install test

# SETUP
install:
	uv sync --dev --frozen

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
	rm -rf .tox .coverage .pytest_cache .venv .python-version .cache
