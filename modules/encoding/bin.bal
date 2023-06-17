import msgpack.core;

type BinEncodingError distinct error<record {int length;}>;

function encodeBin(byte[] data) returns byte[]|BinEncodingError {
    byte first;
    int length_length; // number of bytes to store the array length
    int len = data.length();
    if len < 1 << 8 {
        first = 0xc4;
        length_length = 1;
    } else if len < 1 << 16 {
        first = 0xc5;
        length_length = 2;
    } else if len < 1 << 32 {
        first = 0xc6;
        length_length = 4;
    } else {
        return error BinEncodingError("Cannot encode byte[] that large.", length = len);
    }

    return [first, ...core:toBytes(len, length_length), ...data];
}
