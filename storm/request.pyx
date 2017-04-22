cdef class Request:
    def __init__(self):
        cdef:
            str url = ""
            str http_version = "1.1"
            str http_method = "GET"
            dict headers = {}
            list body = []
