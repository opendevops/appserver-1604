# Testing for local manifest






ssh into vagrant box
```
vagrant ssh
```




### apache


Ensure apache is running worker should output worker
```
a2query -M
```

### php

```
which php
whereis php
```

### /usr/local/bin

```
drwxr-xr-x 2 vagrant vagrant    4096 Oct 29 07:16 cache/
-rwxr-xr-x 1 vagrant root        498 Oct 28 23:00 compass*
-rwxr-xr-x 1 vagrant root        537 Oct 28 22:45 compass-validate*
-rwxr-xr-x 1 vagrant vagrant 1704783 Oct 29 07:17 composer*
lrwxrwxrwx 1 vagrant root         36 Oct 28 22:59 gulp -> ../lib/node_modules/gulp/bin/gulp.js*
-rw-r--r-- 1 vagrant vagrant     799 Oct 29 07:17 keys.dev.pub
-rw-r--r-- 1 vagrant vagrant     799 Oct 29 07:17 keys.tags.pub
lrwxrwxrwx 1 vagrant root         34 Oct 28 23:00 lessc -> ../lib/node_modules/less/bin/lessc*
lrwxrwxrwx 1 vagrant root         28 Oct 28 23:00 phantomjs -> /opt/phantomjs/bin/phantomjs*
-rw-r--r-- 1 vagrant root          0 Oct 29 07:37 php*
-rwxr-xr-x 1 vagrant root        204 Oct 28 22:53 pip*
-rwxr-xr-x 1 vagrant root        204 Oct 28 22:53 pip2*
-rwxr-xr-x 1 vagrant root        204 Oct 28 22:53 pip2.7*
-rwxr-xr-x 1 vagrant root    2231600 Oct 12 23:40 robo*
-rwxr-xr-x 1 vagrant root        486 Oct 28 23:03 sass*
-rwxr-xr-x 1 vagrant root        494 Oct 28 23:03 sass-convert*
-rwxr-xr-x 1 vagrant root        486 Oct 28 23:03 scss*
lrwxrwxrwx 1 vagrant root         41 Oct 28 22:56 uglifyjs -> ../lib/node_modules/uglifyjs/bin/uglifyjs*
```