import logging
import asyncio

import uvloop
import httptools

from storm.request import Request
from storm.response import start_response


asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())


class HTTPProtocol(asyncio.Protocol):
    def __init__(self, app, loop=None):
        logging.debug("HTTPProtocol initialized with loop {}".format(loop))
        self._app = app
        self._loop = loop or asyncio.get_event_loop()
        self._transport = None
        self._request = Request()
        self._parser = httptools.HttpRequestParser(self)

    def connection_made(self, transport):
        logging.debug("connection made with transport {}".format(transport))
        self._transport = transport

    def data_received(self, data):
        logging.debug("received data {}".format(data))
        try:
            self._parser.feed_data(data)
        except httptools.HttpParserError:
            logging.exception("Bad Request")

    def on_url(self, url):
        logging.debug("on url {}".format(url))
        self._request.url = url.decode()

    def on_header(self, name, value):
        logging.debug("on header {}: {}".format(name, value))
        self._request.headers[name] = value

    def on_headers_complete(self):
        logging.debug("headers complete")
        self._request.http_version = self._parser.get_http_version()
        self._request.http_method = self._parser.get_method().decode()

    def on_body(self, body):
        logging.debug("on body {}".format(body))
        self._request.body.append(body)

    def on_message_complete(self):
        logging.debug("message complete")
        if self._request.body:
            self._request.body = b"".join(self._request.body)

        self._loop.create_task(
            start_response(self._app, self._transport, self._request)
        )
