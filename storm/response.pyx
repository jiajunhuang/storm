import asyncio
import inspect
import logging
import traceback
import datetime

from storm.exceptions import NotFoundError


HTTP_STATUS_CODE_MAP = {
    200: "OK",
    404: "Not Found",
    405: "Method Not Allowed",
    500: "Internal Server Error",
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
    cdef str http_method

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
