decoding functionality
[//]: # (above is the module summary)

# Module Overview
this module includes functions for handling decoding [msgpack](https://msgpack.org)-encoded `byte[]` into native `json` types.

`decoding.bal` exposes the `function decode(byte[] data) returns json|error`, which calls format-specific decoding functions.

the other `[format].bal` source files in this folder contain decoding functionality for each supported format.

decoding functions generally take msgpack-encoded data as a `byte[]`, and return a `[json, byte[]]` tuple of the decoded data, followed by the remainder of the encoded data.

most decoding functions will take two arguments, `(byte first, byte[] data)`, since we have the pattern:

```
var [first, newdata] = core:shift(data);
if isFormat(first) {
    return decodeFormat(first, newdata);
}
```

by utilizing the `core:shift` function, we can handle nested arrays and maps by simply pulling off the first chunk of data, and returning the rest of the leftover data for later functions to handle.

the public-facing `function decode(byte[] data) returns json|error`, while the internally-used `function decodeShift(byte[] data) returns [json, byte[]] | error`, returning decoded data and the remainder leftover as described above.
