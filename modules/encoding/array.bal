import msgpack.core;

type ArrayEncodingError distinct error<record {int length;}>;

function encodeArray(json[] data) returns byte[]|EncodingError {
    int data_length = data.length();
    if data_length < 16 {
        return encode_fixarray(data);
    } else if data_length < (1 << 16) {
        return encode_array16(data);
    } else if data_length < (1 << 32) {
        return encode_array32(data);
    } else {
        return error ArrayEncodingError("array too large, not implemented", length = data_length);
    }
}

function encode_fixarray(json[] data) returns byte[]|EncodingError {
    byte[] output = [<byte>(0x90 + data.length())];
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

function encode_array16(json[] data) returns byte[]|EncodingError {
    byte[] output = [0xdc];
    byte[] length_in_bigendian_bytes = core:toBytes(data.length(), 2);
    output.push(...length_in_bigendian_bytes);
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

function encode_array32(json[] data) returns byte[]|EncodingError {
    byte[] output = [0xdd];
    byte[] length_in_bigendian_bytes = core:toBytes(data.length(), 4);
    output.push(...length_in_bigendian_bytes);
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

// TODO: refactor this, don't need three separate but nearly identical functions
