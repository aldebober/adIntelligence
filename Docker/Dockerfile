FROM python:3.5

ADD server.py /

RUN python3.5 -m pip install prometheus_client

EXPOSE 8888 8001
HEALTHCHECK CMD curl --fail http://localhost:8888 || exit 1

CMD [ "python", "./server.py", "8888" ]
