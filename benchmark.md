benchmark for storm: 

```bash
$ ab -n 90000 -c 1000 http://127.0.0.1:8080/
```

```
Server Software:
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /
Document Length:        0 bytes

Concurrency Level:      1000
Time taken for tests:   6.867 seconds
Complete requests:      90000
Failed requests:        0
Non-2xx responses:      90000
Total transferred:      12060000 bytes
HTML transferred:       0 bytes
Requests per second:    13106.53 [#/sec] (mean)
Time per request:       76.298 [ms] (mean)
Time per request:       0.076 [ms] (mean, across all concurrent requests)
Transfer rate:          1715.11 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   40 241.9      1    3040
Processing:     2   26  58.0     21    2130
Waiting:        2   21  58.0     16    2125
Total:          9   66 265.9     22    3267

Percentage of the requests served within a certain time (ms)
  50%     22
  66%     23
  75%     23
  80%     24
  90%     30
  95%     41
  98%   1043
  99%   1248
 100%   3267 (longest request)
```

benchmark for Tornado: 

```bash
$ ab -n 90000 -c 1000 http://127.0.0.1:8080/
```

```
Server Software:        TornadoServer/4.5.1
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /
Document Length:        12 bytes

Concurrency Level:      1000
Time taken for tests:   8.307 seconds
Complete requests:      16740
Failed requests:        0
Total transferred:      3465180 bytes
HTML transferred:       200880 bytes
Requests per second:    2015.07 [#/sec] (mean)
Time per request:       496.261 [ms] (mean)
Time per request:       0.496 [ms] (mean, across all concurrent requests)
Transfer rate:          407.34 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   16 158.3      0    3048
Processing:     1   74 177.3     63    6816
Waiting:        1   74 177.3     63    6816
Total:         11   90 283.0     63    7819

Percentage of the requests served within a certain time (ms)
  50%     63
  66%     64
  75%     64
  80%     65
  90%     69
  95%     70
  98%     99
  99%   1083
 100%   7819 (longest request)
```

benchmark for sanic: 

```bash
$ ab -n 90000 -c 1000 http://127.0.0.1:8080/
```

```
Server Software:
Server Hostname:        127.0.0.1
Server Port:            8080

Document Path:          /
Document Length:        17 bytes

Concurrency Level:      1000
Time taken for tests:   5.186 seconds
Complete requests:      90000
Failed requests:        0
Total transferred:      9630000 bytes
HTML transferred:       1530000 bytes
Requests per second:    17353.71 [#/sec] (mean)
Time per request:       57.625 [ms] (mean)
Time per request:       0.058 [ms] (mean, across all concurrent requests)
Transfer rate:          1813.33 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   34 181.1      1    1042
Processing:     1   16  43.0     13    1673
Waiting:        1   12  42.7     10    1669
Total:          2   50 196.3     15    2711

Percentage of the requests served within a certain time (ms)
  50%     15
  66%     15
  75%     16
  80%     16
  90%     20
  95%     47
  98%   1036
  99%   1047
 100%   2711 (longest request)
```
