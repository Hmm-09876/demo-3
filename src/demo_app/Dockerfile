FROM python:3.11-slim AS builder
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY requirements.txt .
RUN pip install wheel setuptools \
    && pip wheel --no-cache-dir --wheel-dir /wheels -r requirements.txt 

FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY --from=builder /wheels /wheels
COPY . /app/
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt
EXPOSE 8080
HEALTHCHECK --interval=15s --timeout=3s --retries=3 CMD curl -f http://localhost:8080/health || exit 1
CMD [ "python", "app.py" ]