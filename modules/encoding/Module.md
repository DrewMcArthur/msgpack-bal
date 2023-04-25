encoding functionality
[//]: # (above is the module summary)

# Module Overview
this module includes functions for handling encoding `json` variables into `byte[]` according to the [msgpack](https://msgpack.org) spec.

`encoding.bal` has the one public function, `encode`, and it calls format-specific encoding functions.

the other `[format].bal` source files in this folder contain encoding functionality for each supported format.

encoding functions generally take `json`, or a more specific type, and return `byte[]|error`

* note about bin / byte[] data types:  msgpack has a specific encoding 
for arrays of binary data, but ballerina by default converts a byte to an int.
in order to get the byte[]-specific encoding, you can cast the array to a `byte[]`, e.g.:

```
var data = [0x01, 0xcd];
data is byte[]; // false

var byteData = <byte[]>[0x02, 0xef];
byteData is byte[]; // true
```