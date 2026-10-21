FROM python:3.12.4-alpine3.20

WORKDIR /python-docker

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt

CMD [ "python3", "run.py", "-m", "flask", "run", "--host", "0.0.0.0"]