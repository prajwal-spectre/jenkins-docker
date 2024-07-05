FROM python:3.9-slim

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

COPY . .

EXPOSE 5000

ENV NAME World

CMD ["python", "app.py"]
