# Storm: A super fast web framework based on uvloop

Storm是基于uvloop和Cython的一个web框架，其特性为响应巨快，主要得益于libuv和
Cython的速度和框架的精简。

```bash
$ git clone git@github.com:jiajunhuang/storm
$ cd storm
$ make
$ PYTHONPATH=. python3 demo/main.py
```

Demo:

```python
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


handler_classes = [
    (r"/", RootHandler),
]

Application(
    handler_clses=handler_classes,
    debug=False,
).run()
```

```bash
$ PYTHONPATH=. python3 demo/main.py
```

[Benchmark](./benchmark.md)

storm的IOPS约为13106.53，远超Tornado（约2015.07 ），略低于Sanic（约17353.71 ）
storm将在后续优化对象的消耗上，目标是超过Sanic。
