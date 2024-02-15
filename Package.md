msgpack implementation in ballerina

# Package Overview

[see msgpack.org](https://msgpack.org)

this package exposes two functions, `encode` and `decode`,
which handle serialization to and from msgpack-encoded byte arrays.

```
public function encode(any data) returns byte[];
public function decode(byte[] data) returns any;
```

this package is NOT feature complete. feel free to contribute!
see the readme and repository for completion.
