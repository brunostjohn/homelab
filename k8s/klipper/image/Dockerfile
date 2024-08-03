FROM python:3.11-bookworm AS klipper-cloner

RUN apt update \
 && apt install -y \
    git cmake

WORKDIR /opt

RUN git clone https://github.com/jpcurti/ender3-v3-se-klipper-with-display.git \
 && mv ender3-v3-se-klipper-with-display klipper \
 && rm -rf /opt/klipper/.git

RUN python -m venv venv \
 && venv/bin/pip install -r klipper/scripts/klippy-requirements.txt \
 && venv/bin/python -m compileall klipper/klippy \
 && venv/bin/python klipper/klippy/chelper/__init__.py

FROM python:3.11-bookworm AS moonraker-cloner

WORKDIR /opt

RUN git clone https://github.com/Arksine/moonraker moonraker \
 && rm -rf /opt/moonraker/.git

RUN python -m venv venv \
 && venv/bin/pip install -r moonraker/scripts/moonraker-requirements.txt

FROM python:3.11-slim-bookworm AS runner

WORKDIR /opt

RUN apt update \
 && apt install -y socat sudo libsodium-dev \
 && groupadd klipper --gid 1000 \
 && useradd klipper --uid 1000 --gid klipper \
 && usermod klipper --append --groups dialout \
 && usermod klipper --append --groups tty \
 && mkdir -p /opt/klipper /opt/printer_data/run /opt/runwatch \
    /opt/printer_data/gcodes /opt/printer_data/logs /opt/printer_data/config \
    /opt/printer_data/database /opt/run \
 && chown -cR klipper:klipper /opt/* \
 && adduser klipper sudo \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=klipper:klipper --from=klipper-cloner /opt/klipper /opt/klipper
COPY --chown=klipper:klipper --from=klipper-cloner /opt/venv /opt/venv-klipper
COPY --chown=klipper:klipper --from=moonraker-cloner /opt/moonraker /opt/moonraker
COPY --chown=klipper:klipper --from=moonraker-cloner /opt/venv /opt/venv-moonraker
COPY --chown=klipper:klipper runwatch/run.sh /opt/runwatch/run.sh
# COPY --chown=klipper:klipper runwatch/100.socat-printer.enabled.sh /opt/runwatch/100.socat-printer.enabled.sh
COPY --chown=klipper:klipper runwatch/200.klipper.enabled.sh /opt/runwatch/200.klipper.enabled.sh
COPY --chown=klipper:klipper runwatch/300.moonraker.enabled.sh /opt/runwatch/300.moonraker.enabled.sh

RUN chmod +x /opt/runwatch/*.sh

USER klipper
EXPOSE 7125
VOLUME ["/opt/printer_data"]
ENTRYPOINT /opt/runwatch/run.sh