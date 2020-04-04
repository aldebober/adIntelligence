#!/usr/bin/python3

"""
Very simple HTTP server in python
Usage::
        ./server.py [<port>]
        """
from sys import argv
from http.server import HTTPServer, BaseHTTPRequestHandler
import prometheus_client
import time

HELLO_REQUESTS = prometheus_client.Counter("hello_world_total","Number of hello worlds requested")
NOT_FOUND_REQUESTS = prometheus_client.Counter("not_found_total","Number of 404 requested")
LATENCY = prometheus_client.Summary("hello_world_latency_seconds","Time it takes for a hello world to happen")

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        start = time.time()
        if self.path == "/":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Success')
            HELLO_REQUESTS.inc()
        try:
            if self.path == "/ping":
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'OK')
            else:
                self.send_response(404)
                self.wfile.write(b'File Not Found')
                NOT_FOUND_REQUESTS.inc()
            return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)
        LATENCY.observe(time.time() - start)


if len(argv) == 2:
    httpd = HTTPServer(('0.0.0.0', int(argv[1])), SimpleHTTPRequestHandler)
else:
    httpd = HTTPServer(('0.0.0.0', 8000), SimpleHTTPRequestHandler)
prometheus_client.start_http_server(8001)
httpd.serve_forever()
