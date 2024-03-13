#FROM ubuntu:22.04

#probably better:
FROM python:3.10-slim-bookworm


ENV PYTHONUNBUFFERED True
ARG DEBIAN_FRONTEND=noninteractive

COPY . /app

WORKDIR /app

RUN usermod -s /bin/bash root
RUN usermod -s /bin/bash $(whoami)

RUN apt-get update && apt-get upgrade -y
RUN apt-get install curl nano python3 python3-dev python-is-python3 build-essential -y
RUN python -m pip install --upgrade pip
RUN pip install --upgrade setuptools wheel 

RUN pip install -r requirements.txt

RUN pip install -q nvidia-smi

RUN pip install -e .


# NGROK
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null 
# bookworm does not exist yet for this:  RUN echo "deb https://ngrok-agent.s3.amazonaws.com bookworm main" | tee /etc/apt/sources.list.d/ngrok.list 
RUN echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list 
RUN apt-get update && apt-get install ngrok -y

CMD ["sleep", "infinity"]
