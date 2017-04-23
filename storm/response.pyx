import asyncio
import inspect
import logging
import traceback
import datetime

from storm.exceptions import NotFoundError

HTTP_STATUS_CODE_MAP = {
    100: 'Continue',
    101: 'Switching Protocols',
    102: 'Processing',
    200: 'OK',
    201: 'Created',
    202: 'Accepted',
    203: 'Non-Authoritative Information',
    204: 'No Content',
    205: 'Reset Content',
    206: 'Partial Content',
    207: 'Multi-Status',
    208: 'Already Reported',
    226: 'IM Used',
    300: 'Multiple Choices',
    301: 'Moved Permanently',
    302: 'Found',
    303: 'See Other',
    304: 'Not Modified',
    305: 'Use Proxy',
    307: 'Temporary Redirect',
    308: 'Permanent Redirect',
    400: 'Bad Request',
    401: 'Unauthorized',
    402: 'Payment Required',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Timeout',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Request Entity Too Large',
    414: 'Request-URI Too Long',
    415: 'Unsupported Media Type',
    416: 'Requested Range Not Satisfiable',
    417: 'Expectation Failed',
    422: 'Unprocessable Entity',
    423: 'Locked',
    424: 'Failed Dependency',
    426: 'Upgrade Required',
    428: 'Precondition Required',
    429: 'Too Many Requests',
    431: 'Request Header Fields Too Large',
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    506: 'Variant Also Negotiates',
    507: 'Insufficient Storage',
    508: 'Loop Detected',
    510: 'Not Extended',
    511: 'Network Authentication Required'
}


class HTTPResponse:
    def __init__(
            self,
            int status=200,
            str content_type="text/json",
            str headers="",
            str body="",
    ):
        self.status = status
        self.content_type = content_type
        self.headers = headers
        self.body = body

    def output(self, str http_version="1.1"):
        return (
            "HTTP/{http_version} {http_status} {http_status_code}\r\n"
            "Content-Length: {content_length}\r\n"
            "Content-Type: {content_type}; charset=UTF-8\r\n"
            "Date: {date}\r\n"
            "{headers}\r\n"
            "{body}"
        ).format(
            http_version=http_version,
            http_status=self.status,
            http_status_code=HTTP_STATUS_CODE_MAP[self.status],
            content_length=len(self.body),
            content_type=self.content_type,
            date=datetime.datetime.utcnow().strftime(
                '%a, %d %b %Y %H:%M:%S GMT'
            ),
            headers=self.headers,
            body=self.body,
        ).encode()


async def start_response(app, transport, request):
    cdef:
        str http_method
        list params
        object handler_cls

    logging.debug("start to response")
    try:
        handler_cls, params = app.get_handler_cls(request.url)
    except NotFoundError:
        response = HTTPResponse(404)
    else:
        try:
            handler = handler_cls(app, request)
            handler.before_handle()
            # call get/post/...
            http_method = request.http_method.lower()
            if http_method in (
                    "get", "post", "put", "delete", "patch", "options"
            ):
                http_handler = getattr(handler, request.http_method.lower())
                logging.debug(
                    "handler {} are calling with params: {}".format(
                        http_handler,
                        params,
                    )
                )
                if params:
                    may_awaitable = http_handler(*params)
                else:
                    may_awaitable = http_handler()
                if inspect.isawaitable(may_awaitable):
                    await may_awaitable
            else:
                raise NotImplementedError()
        except NotImplementedError:
            handler.status = 405
        except:
            if app.debug:
                body = traceback.format_exc()
            else:
                body = ""

            response = HTTPResponse(
                status=500,
                body=body,
            )
        else:
            response = HTTPResponse(
                handler.status,
                handler.content_type,
                "\r\n".join(handler.headers),
                "".join(handler.body)
            )
            handler.after_handle()

    transport.write(response.output())
    transport.close()
