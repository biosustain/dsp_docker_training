FROM python:3.14-slim

COPY requirements.txt /app/

RUN pip install -r /app/requirements.txt

COPY main.py /app/

CMD ["python", "/app/main.py"]
