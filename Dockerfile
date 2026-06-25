# ── Stage 1: dependency builder ──────────────────────────────────────────────
FROM python:3.12-slim AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Copy only dependency files first (better layer caching)
COPY pyproject.toml uv.lock ./

# Install production dependencies into an isolated location
RUN uv sync --frozen --no-dev --no-install-project

# ── Stage 2: runtime image ───────────────────────────────────────────────────
FROM python:3.12-slim AS runtime

# Non-root user for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app

# Copy the virtual env from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application source
COPY app/ ./app/
COPY main.py ./

# Make sure scripts in .venv are usable
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
