# =============================================================================
# Expense Tracker Backend — Makefile
# =============================================================================
#
# USAGE
#   make <target>
#
# AVAILABLE COMMANDS
#
#   Setup
#     install       Install all dependencies including dev extras
#
#   Development server
#     run           Start the server in production mode (no reload)
#     dev           Start the server with hot-reload enabled
#
#   Code quality  (powered by ruff)
#     lint          Check code for lint errors
#     format        Check code formatting without making changes
#     fix           Auto-fix lint issues and apply formatting in one step
#     check         Run lint + format check together (no changes made)
#
#   Testing
#     test          Run the full test suite
#     test-cov      Run tests and generate an HTML + terminal coverage report
#
#   Docker
#     docker-build  Build the Docker image
#     docker-up     Start all services in detached mode
#     docker-down   Stop and remove all containers
#     docker-logs   Tail logs from all running services
#
#   Migrations  (Alembic + Neon Postgres)
#     db-migrate    Autogenerate a new migration from model changes
#     db-upgrade    Apply all pending migrations to the database
#     db-downgrade  Roll back the last applied migration
#     db-history    Show the full migration history
#     db-current    Show which migration the database is currently on
#
#   Utilities
#     help          Print this command reference
#     clean         Remove __pycache__, .pyc files, and test/coverage artefacts
#
# =============================================================================

.PHONY: install run dev lint format fix check test test-cov \
        docker-build docker-up docker-down docker-logs \
        db-migrate db-upgrade db-downgrade db-history db-current \
        help clean


# ----------------------------------------------------------------------------
# Setup
# ----------------------------------------------------------------------------

install:
	uv sync --all-groups


# ----------------------------------------------------------------------------
# Development server
# ----------------------------------------------------------------------------

run:
	uv run uvicorn app.main:app --host 0.0.0.0 --port 8000

dev:
	uv run uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload


# ----------------------------------------------------------------------------
# Code quality
# ----------------------------------------------------------------------------

lint:
	uv run ruff check .

format:
	uv run ruff format --check .

fix:
	uv run ruff check --fix .
	uv run ruff format .

check: lint format


# ----------------------------------------------------------------------------
# Testing
# ----------------------------------------------------------------------------

test:
	uv run pytest

test-cov:
	uv run pytest --cov=app --cov-report=term-missing --cov-report=html


# ----------------------------------------------------------------------------
# Migrations
# ----------------------------------------------------------------------------

# Usage: make db-migrate m="describe your change"
db-migrate:
	uv run alembic revision --autogenerate -m "$(m)"

db-upgrade:
	uv run alembic upgrade head

db-downgrade:
	uv run alembic downgrade -1

db-history:
	uv run alembic history --verbose

db-current:
	uv run alembic current


# ----------------------------------------------------------------------------
# Docker
# ----------------------------------------------------------------------------

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down

docker-logs:
	docker compose logs -f


# ----------------------------------------------------------------------------
# Utilities
# ----------------------------------------------------------------------------

help:
	@printf "\nExpense Tracker Backend — available make commands\n"
	@printf "%0.s=" {1..54}; printf "\n"
	@printf "\n  \033[4mSetup\033[0m\n"
	@printf "    \033[36mmake install\033[0m\n"
	@printf "        Install all project dependencies including dev extras\n"
	@printf "        via uv (reads pyproject.toml + uv.lock)\n"
	@printf "\n  \033[4mDevelopment server\033[0m\n"
	@printf "    \033[36mmake run\033[0m\n"
	@printf "        Start uvicorn in production mode (no auto-reload)\n"
	@printf "    \033[36mmake dev\033[0m\n"
	@printf "        Start uvicorn with --reload so the server restarts\n"
	@printf "        automatically on every file change\n"
	@printf "\n  \033[4mCode quality  (powered by ruff)\033[0m\n"
	@printf "    \033[36mmake lint\033[0m\n"
	@printf "        Run the ruff linter and report all rule violations\n"
	@printf "    \033[36mmake format\033[0m\n"
	@printf "        Check formatting without writing any changes\n"
	@printf "        (safe to run in CI)\n"
	@printf "    \033[36mmake fix\033[0m\n"
	@printf "        Auto-fix all fixable lint issues, then apply ruff\n"
	@printf "        formatting — modifies files in place\n"
	@printf "    \033[36mmake check\033[0m\n"
	@printf "        Run both lint and format checks together without\n"
	@printf "        making any changes (shortcut for CI pipelines)\n"
	@printf "\n  \033[4mTesting\033[0m\n"
	@printf "    \033[36mmake test\033[0m\n"
	@printf "        Run the full pytest test suite\n"
	@printf "    \033[36mmake test-cov\033[0m\n"
	@printf "        Run tests and produce a terminal summary plus an\n"
	@printf "        HTML coverage report under htmlcov/\n"
	@printf "\n  \033[4mDocker\033[0m\n"
	@printf "    \033[36mmake docker-build\033[0m\n"
	@printf "        Build the application Docker image\n"
	@printf "    \033[36mmake docker-up\033[0m\n"
	@printf "        Start the app and database containers in the\n"
	@printf "        background (detached mode)\n"
	@printf "    \033[36mmake docker-down\033[0m\n"
	@printf "        Stop and remove all running containers\n"
	@printf "    \033[36mmake docker-logs\033[0m\n"
	@printf "        Tail live logs from all running services\n"
	@printf "\n  \033[4mMigrations  (Alembic + Neon Postgres)\033[0m\n"
	@printf "    \033[36mmake db-migrate m=\"describe change\"\033[0m\n"
	@printf "        Autogenerate a new migration file from model changes\n"
	@printf "        Example: make db-migrate m=\"add users table\"\n"
	@printf "    \033[36mmake db-upgrade\033[0m\n"
	@printf "        Apply all pending migrations to the database\n"
	@printf "    \033[36mmake db-downgrade\033[0m\n"
	@printf "        Roll back the last applied migration\n"
	@printf "    \033[36mmake db-history\033[0m\n"
	@printf "        Show the full migration history with details\n"
	@printf "    \033[36mmake db-current\033[0m\n"
	@printf "        Show which migration the database is currently on\n"
	@printf "\n  \033[4mUtilities\033[0m\n"
	@printf "    \033[36mmake help\033[0m\n"
	@printf "        Print this command reference\n"
	@printf "    \033[36mmake clean\033[0m\n"
	@printf "        Remove __pycache__, .pyc files, .pytest_cache,\n"
	@printf "        htmlcov/, and .coverage artefacts\n"
	@printf "\n"

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	rm -rf .pytest_cache htmlcov .coverage
