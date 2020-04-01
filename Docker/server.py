#!/usr/bin/python3

"""
Very simple HTTP server in python
Usage::
        ./server.py [<port>]
        """
from sys import argv
from http.server import HTTPServer, BaseHTTPRequestHandler


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Success')
        try:
            if self.path == "/ping":
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b'OK')
            else:
                self.send_response(404)
                self.wfile.write(b'File Not Found')
            return
        except IOError:
            self.send_error(404,'File Not Found: %s' % self.path)


if len(argv) == 2:
    httpd = HTTPServer(('0.0.0.0', int(argv[1])), SimpleHTTPRequestHandler)
else:
    httpd = HTTPServer(('0.0.0.0', 8000), SimpleHTTPRequestHandler)
httpd.serve_forever()
