# Use python:3.13 instead of 3.14 to save time during this example.
# NumPy 2.2.6 has no pre-built wheels for python:3.14, which would require
# compiling it from source and significantly slow down the build.
FROM python:3.13

RUN pip install numpy==2.2.6

# RUN pip install numpy

COPY main.py /app/main.py

CMD ["python", "/app/main.py"]
