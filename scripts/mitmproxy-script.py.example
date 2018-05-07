#!/usr/bin/env python

from mitmproxy import io
from mitmproxy.exceptions import FlowReadException


outputpath = '/home/chrome/output/'

def response(flow):
    content_type = flow.response.headers.get('Content-Type', '')
    path = flow.request.url.replace('/', '_').replace(':', '_')
    if content_type.startswith('text/html'):
        with open(outputpath + path, 'w') as f:
            f.write(flow.response.text)
