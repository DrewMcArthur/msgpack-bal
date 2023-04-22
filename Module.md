msgpack implementation in ballerina
[//]: # (above is the module summary)

# Module Overview
[see msgpack.org](https://msgpack.org)
this package exposes two functions, `encode` and `decode`,
which handle serialization to and from msgpack-encoded byte arrays.

```
public function encode(any data) returns byte[];
public function decode(byte[] data) returns any;
```

so far, only implement small maps and strings, this package is a WIP.
