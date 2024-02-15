msgpack implementation in ballerina

# Module Overview

[see msgpack.org](https://msgpack.org)

this package exposes two functions, `encode` and `decode`,
which handle serialization to and from msgpack-encoded byte arrays.

```
public function encode(any data) returns byte[];
public function decode(byte[] data) returns any;
```

this package is NOT feature complete. feel free to contribute!
see [README.md](https://github.com/drewmcarthur/msgpack-bal) and repository for completion.

## usage

```
import ballerina/io;
import drewmca/msgpack;

json obj = {"hello": "world!"}

byte[] encoded = msgpack:encode(obj);
json decoded = msgpack:decode(encoded);

io:println(decoded);
```

## repository

[github.com/drewmcarthur/msgpack-bal](https://github.com/drewmcarthur/msgpack-bal)
