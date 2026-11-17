FROM python:3.14-slim

RUN pip install \
    numpy==2.5.5 \
    pandas==3.1.1

COPY main.py /app/main.py

CMD ["python", "/app/main.py"]
