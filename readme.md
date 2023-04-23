# msgpack-bal

an implementation of the [msgpack](https://msgpack.org) spec in ballerina.

WIP, will add a tracker of what i've implemented so far.

### Formats implemented

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
    - [ ] Int64
- [ ] float format family
    - [ ] Float32
    - [ ] Float64
- [ ] str format family
    - [x] FixStr 
    - [ ] Str8
    - [ ] Str16
    - [ ] Str32
- [ ] bin format family
    - [ ] Bin8
    - [ ] Bin16
    - [ ] Bin32
- [ ] array format family
    - [x] FixArray
    - [ ] Array16
    - [ ] Array32
- [ ] map format family
    - [x] FixMap
    - [ ] Map16
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
- **v0.4**: added benchmarks, coreutil for int->byte[] map16, int impl
- **v1.0**: full compatibility with the msgpack spec, including a full test suite and benchmarks
- **v2.0**: refactored codebase including using the input data as a fifo stack for decoding
- **v3.0**: ???

### TODO:

- [ ] create a big json file of test cases
- [x] put a checkbox of msgpack format types here 
- [ ] separate functions into different files
- [ ] refactor decoding to pop bytes off the array
