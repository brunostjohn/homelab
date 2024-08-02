ARG PYTHON_BASE_IMAGE=3-slim-buster

FROM python:${PYTHON_BASE_IMAGE} AS build

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  ffmpeg \
  libffi-dev \
  socat \
  bash \
  procps \
  sudo

RUN groupadd --gid 1000 octoprint \
  && useradd --uid 1000 --gid octoprint -G dialout --shell /bin/bash -m octoprint \
  && mkdir -p /octoprint/octoprint /octoprint/plugins \
  && chown -R octoprint:octoprint /octoprint \
  && adduser octoprint sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /home/octoprint/runwatch
COPY runwatch/run.sh /home/octoprint/runwatch/run.sh

COPY runwatch/200.octoprint.enabled.sh /home/octoprint/runwatch/200.octoprint.enabled.sh
COPY runwatch/100.socat-printer.enabled.sh /home/octoprint/runwatch/100.socat-printer.enabled.sh

RUN chmod +x /home/octoprint/runwatch/*.sh \
  && chown -R octoprint:octoprint /home/octoprint/runwatch

USER octoprint
WORKDIR /home/octoprint

ENV PYTHONUSERBASE /octoprint/plugins
ENV PIP_USER true
ENV PATH "${PYTHONUSERBASE}/bin:${PATH}"

ARG octoprint_ref 
ENV octoprint_ref ${octoprint_ref:-master}


RUN	mkdir tmp && curl -fsSLO --compressed --retry 3 --retry-delay 10 \
  https://github.com/OctoPrint/OctoPrint/archive/${octoprint_ref}.tar.gz \
  && tar xzf ${octoprint_ref}.tar.gz --strip-components 1 -C tmp \
  && cd /home/octoprint/tmp \
  && pip install . \
  && rm -rf /home/octoprint/tmp

WORKDIR /octoprint

COPY config.yaml /octoprint/octoprint

VOLUME /octoprint
EXPOSE 5000

ENTRYPOINT /home/octoprint/runwatch/run.sh