FROM python:3.5     # Weights a lot, you can use alpine and apk add python3 instead.

ADD server.py /

EXPOSE 8888
HEALTHCHECK CMD curl --fail http://localhost:8888 || exit 1

CMD [ "python", "./server.py", "8888" ]
