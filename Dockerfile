FROM apache/spark:4.0.1-python3 AS base
FROM python:3.13-slim

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    openjdk-17-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/*

RUN curl -sSL https://astral.sh/uv/0.9.5/install.sh | sh && \
    rm -rf /tmp/*

ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

COPY pyproject.toml uv.lock* ./

# Faster build: skip bytecode compilation, use prefer-binary
RUN uv venv /app/.venv && \
    uv sync \
    --python /app/.venv/bin/python \
    --prefer-binary \
    --no-editable && \
    rm -rf /root/.cache

COPY src/ ./src/

RUN test -f "/app/.venv/bin/python"

ENV PYSPARK_PYTHON=/app/.venv/bin/python \
    PYSPARK_DRIVER_PYTHON=/app/.venv/bin/python \
    PATH="/app/.venv/bin:$PATH" \
    ROLE=driver \
    PYTHONUNBUFFERED=1

EXPOSE 8888 7077 8081

CMD if [ "$ROLE" = "worker" ]; then \
      /opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077; \
    else \
      jupyter-lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=''; \
    fi