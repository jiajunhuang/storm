import json


class RequestHandler:
    def __init__(self, app, request):
        cdef:
            int status
            str content_type
            list headers
            list body

        self._app = app
        self.request = request
        self.status = 200
        self.content_type = "text/json"
        self.headers = []
        self.body = []

        # initial hook
        self.initialize()

    def write(self, body):
        """accept string or dict"""
        if isinstance(body, dict):
            body = json.dumps(body)
        self.body.append(body)

    # Hooks
    def initialize(self):
        pass

    def before_handle(self):
        pass

    def after_handle(self):
        pass

    # HTTP methods
    async def head(self):
        raise NotImplementedError()

    async def patch(self):
        raise NotImplementedError()

    async def get(self):
        raise NotImplementedError()

    async def post(self):
        raise NotImplementedError()

    async def put(self):
        raise NotImplementedError()

    async def delete(self):
        raise NotImplementedError()

    async def options(self):
        raise NotImplementedError()
