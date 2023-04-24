# msgpack-bal

an implementation of the [msgpack](https://msgpack.org) spec in ballerina.

!!! this library is still a WIP, see the [progress tracker](#formats-implemented) below.

## how to use

i won't publish this onto ballerina central until it hits v1, so if
you'd like to use v0, you can clone the repo, package it and publish 
it to your local repository:
```bash
bal pack && bal push --repository local
```
and then import it from your ballerina project by tossing this into your `Ballerina.toml` file
```toml
[[dependency]]
org="drewmca"
name="msgpack"
version="0.0.4"
repository="local"
```
and your editor should see the module and let you use the library, something like this:
```bal
import ballerina/io;
import drewmca/msgpack;
json obj = {"hello": "world!"}
byte[] encoded = msgpack:encode(obj);
json decoded = msgpack:decode(encoded);
io:println(decoded);
```

## Formats implemented

from the [msgpack format spec](https://github.com/msgpack/msgpack/blob/master/spec.md#formats)

- [x] nil format
    - [x] nil
- [x] bool format family
    - [x] true
    - [x] false
- [ ] int format family
    - [x] PositiveFixInt
    - [x] NegativeFixInt
    - [x] Uint8
    - [x] Uint16
    - [x] Uint32
    - [x] Uint64
    - [x] Int8
    - [x] Int16
    - [x] Int32
    - [ ] Int64 (not implemented bc ballerina cannot do `1 << 64`)
- [ ] float format family
    - [ ] Float32
    - [ ] Float64
- [x] str format family
    - [x] FixStr 
    - [x] Str8
    - [x] Str16
    - [ ] Str32 (implemented but untested)
- [ ] bin format family
    - [ ] Bin8
    - [ ] Bin16
    - [ ] Bin32
- [x] array format family
    - [x] FixArray
    - [x] Array16
    - [ ] Array32 (implemented but untested)
- [x] map format family
    - [x] FixMap
    - [x] Map16
    - [ ] Map32
- [ ] ext format family
    - [ ] Ext8
    - [ ] Ext16
    - [ ] Ext32
    - [ ] FixExt1
    - [ ] FixExt2
    - [ ] FixExt4
    - [ ] FixExt8
    - [ ] FixExt16
- [ ] Timestamp extension type

## Roadmap

This is a quick and dirty implementation, generally building out functionality first and will refactor after.

- **v0.3**: implementation of some, but not all of the spec.  quick & dirty implementation.
- **v0.4**: added benchmarks, coreutil for int->byte[] map16, str, & int impl
- **v1.0**: full compatibility with the msgpack spec, including a full test suite and benchmarks
- **v2.0**: refactored codebase including using the input data as a fifo stack for decoding
- **v3.0**: ???

### TODO:

- [ ] create a big json file of test cases
- [x] put a checkbox of msgpack format types here 
- [x] separate functions into different files
- [ ] refactor decoding to pop bytes off the array
      e.g.

``` 
byte first = shift(data);
match first {
    var b if isStr(b) => {
        // pops 1,2,4 bytes off data, so no need to return offset 
        // like we do now.  depends on how ballerina does 
        // array references, if we're passing a copy or by reference here.
        var length = getStrLength(b, data); 
        handleStr(data, length);
    }
}
