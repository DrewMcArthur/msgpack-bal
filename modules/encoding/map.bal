import msgpack.core;

function encode_map(map<json> data) returns byte[]|EncodingError {
    int length = 0;
    byte[] output = [];
    foreach string key in data.keys() {
        length = length + 1;
        byte[] encoded_key = check encode(key);
        output.push(...encoded_key);
        byte[] encoded_val = check encode(data[key]);
        output.push(...encoded_val);
    }

    byte[] first;
    if length < 16 {
        first = [<byte>(0x80 + length)];
    } else if length < 1 << 16 {
        first = [0xde, ...core:toBytes(length, 2)];
    } else if length < 1 << 32 {
        first = [0xdf, ...core:toBytes(length, 4)];
    } else {
        return error MapEncodingError("maps with length > 2^32 are not supported.", length = length);
    }

    return [...first, ...output];
}

type MapEncodingError distinct error<record {int length;}>;
