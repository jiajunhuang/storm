import logging

from storm.app import Application
from storm.handler import RequestHandler


class RootHandler(RequestHandler):
    def initialize(self):
        logging.debug("initialize been called")

    async def get(self):
        self.write({
            "hello": "world"
        })


class NotFoundHandler(RequestHandler):
    pass


class ExceptionHandler(RequestHandler):
    def get(self):
        raise


class BitchHandler(RequestHandler):
    def get(self, num):
        self.write({
            "got": num
        })


handler_classes = [
    (r"/", RootHandler),
    (r"/notfound", NotFoundHandler),
    (r"/exc", ExceptionHandler),
    (r"/bad/(\d+)", ExceptionHandler),
    (r"/num/(\d+)", BitchHandler),
]

Application(
    handler_clses=handler_classes,
    debug=False,
).run()
