class Request:
    def __init__(self):
        self.url = None
        self.http_version = "1.1"
        self.http_method = "GET"
        self.headers = {}
        self.body = []
