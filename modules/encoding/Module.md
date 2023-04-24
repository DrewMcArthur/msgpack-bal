encoding functionality
[//]: # (above is the module summary)

# Module Overview
this module includes functions for handling encoding `json` variables into `byte[]` according to the [msgpack](https://msgpack.org) spec.

`encoding.bal` has the one public function, `encode`, and it calls format-specific encoding functions.

the other `[format].bal` source files in this folder contain encoding functionality for each supported format.

encoding functions generally take `json`, or a more specific type, and return `byte[]|error`
