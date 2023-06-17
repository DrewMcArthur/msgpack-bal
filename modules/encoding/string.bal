function encode_string(string data) returns byte[]|StringEncodingError {
    byte[] first = check getStrlenIndicatorBytes(data.length());
    return [...first, ...data.toBytes()];
}

// given the length of a string, return the leading indicators according to msgpack
// https://github.com/msgpack/msgpack/blob/master/spec.md#str-format-family
function getStrlenIndicatorBytes(int len) returns byte[]|StringEncodingError {
    if len < 32 {
        return [<byte>(0xa0 + len)];
    }
    byte indicator;
    byte[] lenBytes = unsignedIntToBytes(len);
    if len < (1 << 8) {
        indicator = 0xd9;
    } else if len < (1 << 16) {
        indicator = 0xda;
    } else if len < (1 << 32) {
        indicator = 0xdb;
    } else {
        return error StringEncodingError("strings that large not supported", length = len);
    }
    return [indicator, ...lenBytes];
}

type StringEncodingError distinct error<record {int length;}>;
