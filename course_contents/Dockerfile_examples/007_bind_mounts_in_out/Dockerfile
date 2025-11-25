FROM python:3.14-slim

RUN pip install pandas==2.3.3

COPY main.py /app/
COPY input.csv /data/in/

RUN mkdir /data/out

CMD ["python", "/app/main.py"]
