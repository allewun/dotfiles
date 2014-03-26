# http://pastebin.com/c6hT5iwa

import traceback
import socket
import ssl
import http.server
import sys
import mimetypes
from os.path import expanduser

PORT = 4443

def do_request(connstream, from_addr):
    x = object()
    http.server.SimpleHTTPRequestHandler.extensions_map = {'.ipa': 'application/octet-stream', '.html': 'text/html', '': 'text/xml'}
    http.server.SimpleHTTPRequestHandler(connstream, from_addr, x)

def serve(host):
    bindsocket = socket.socket()
    bindsocket.bind((host, 4443))
    bindsocket.listen(5)

    print("Serving HTTPS on", host, "port", PORT, "...")

    while True:
        try:
            newsocket, from_addr = bindsocket.accept()
            connstream = ssl.wrap_socket(newsocket,
                                        server_side = True,
                                        certfile = expanduser("~") + "/dotfiles/scripts/https-server/server.pem",
                                        ssl_version = ssl.PROTOCOL_TLSv1)

            do_request(connstream, from_addr)

        except Exception:
            traceback.print_exc()


if len(sys.argv) > 1:
    arg = sys.argv[1]
else:
    arg = None

serve('localhost' if not arg else arg)