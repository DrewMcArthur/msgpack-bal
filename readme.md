# msgpack-bal

an implementation of the [msgpack](https://msgpack.org) spec in ballerina.

WIP, will add a tracker of what i've implemented so far.

### Formats implemented

- [x] PositiveFixInt
- [ ] NegativeFixInt
- [x] FixStr
- [ ] Str16
- [x] FixArray
- [x] FixMap
- [ ] Map16

## Roadmap

This is a quick and dirty implementation, generally building out functionality first and will refactor after.

- **v0.3**: (current version) implementation of some, but not all of the spec.  quick & dirty implementation.
- **v1.0**: full compatibility with the msgpack spec, including a full test suite and benchmarks
- **v2.0**: refactored codebase including using the input data as a fifo stack for decoding
- **v3.0**: ???

### TODO:

- [ ] create a big json file of test cases
- [x] put a checkbox of msgpack format types here 
- [ ] separate functions into different files
- [ ] refactor decoding to pop bytes off the array
