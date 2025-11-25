FROM python:3.14-slim

RUN pip install \
    numpy==2.3.5 \
    pandas==2.3.3

COPY main.py /app/main.py

CMD ["python", "/app/main.py"]
