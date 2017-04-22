import functools
import logging
import asyncio
import re

from storm.server import HTTPProtocol
from storm.exceptions import NotFoundError


class Application:
    def __init__(
            self,
            log_level=logging.INFO,
            handler_clses=None,
            ignore_slash=True,
            debug=False,
    ):
        self.debug = debug
        if self.debug:
            log_level = logging.DEBUG

        logging.basicConfig(level=log_level)
        self._loop = asyncio.get_event_loop()

        self.ignore_slash = ignore_slash
        # handler classes should be a list of tuple like: (url_regex, Handler)
        self._handler_classes = []
        for regex, handler_cls in handler_clses:
            if not regex.startswith(r"^"):
                regex = r"^" + regex
            if not regex.endswith(r"$"):
                if self.ignore_slash:
                    append = r"/?$"
                else:
                    append = r"$"

                regex = regex + append

            regex = re.compile(regex)
            self._handler_classes.append(
                (regex, handler_cls)  # a tuple
            )

    def run(self, host="127.0.0.1", port=8080):
        try:
            self._loop.run_until_complete(
                self._loop.create_server(
                    functools.partial(HTTPProtocol, self, self._loop),
                    host,
                    port,
                )
            )
            logging.warn("Serving on {}:{}".format(host, port))
            self._loop.run_forever()
        except KeyboardInterrupt:
            self._loop.stop()

    def get_handler_cls(self, url):
        logging.debug("request url is {}".format(url))

        for regex, handler in self._handler_classes:
            if regex.match(url):
                return handler, regex.findall(url)

        raise NotFoundError("no handlers found for {}".format(url))
