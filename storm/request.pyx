class Request:
    def __init__(self):
        cdef:
            str url
            str http_version
            str http_method
            dict headers
            list body

        self.url = ""
        self.http_version = "1.1"
        self.http_method = "GET"
        self.headers = {}
        self.body = []
