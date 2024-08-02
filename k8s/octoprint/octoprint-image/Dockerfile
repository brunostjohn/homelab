ARG PYTHON_BASE_IMAGE=3-slim-buster

FROM python:${PYTHON_BASE_IMAGE} AS build

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  ffmpeg \
  libffi-dev \
  socat \
  bash

RUN mkdir -p /octoprint/octoprint /octoprint/plugins /app

WORKDIR /app

ENV PYTHONUSERBASE /octoprint/plugins
ENV PIP_USER true
ENV PATH "${PYTHONUSERBASE}/bin:${PATH}"

ARG octoprint_ref 
ENV octoprint_ref ${octoprint_ref:-master}

RUN	mkdir tmp && curl -fsSLO --compressed --retry 3 --retry-delay 10 \
  https://github.com/OctoPrint/OctoPrint/archive/${octoprint_ref}.tar.gz \
  && tar xzf ${octoprint_ref}.tar.gz --strip-components 1 -C tmp \
  && cd /app/tmp \
  && pip install . \
  && rm -rf /app/tmp

WORKDIR /octoprint
COPY config.yaml /octoprint/octoprint

VOLUME /octoprint
EXPOSE 5000

RUN mkdir /runwatch
COPY runwatch/run.sh /runwatch/run.sh

COPY runwatch/200.octoprint.enabled.sh /runwatch/200.octoprint.enabled.sh
COPY runwatch/100.socat-printer.enabled.sh /runwatch/100.socat-printer.enabled.sh

RUN chmod +x /runwatch/*.sh

ENTRYPOINT /runwatch/run.sh