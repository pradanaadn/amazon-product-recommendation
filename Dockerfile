FROM python:3.13-slim-bookworm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
       openjdk-17-jdk-headless \
       ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

WORKDIR /app

COPY pyproject.toml .
RUN uv sync

COPY src/ ./src/

EXPOSE 8888

# Run JupyterLab (insecure token for dev only)
CMD ["uv", "run", "jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
