FROM python:3.14-slim

RUN pip install pandas==3.1.1

COPY main.py /app/
COPY input.csv /data/in/

RUN mkdir /data/out

CMD ["python", "/app/main.py"]
