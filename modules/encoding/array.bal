import msgpack.core;

function encode_array(json[] data) returns byte[]|error {
    int data_length = data.length();
    if data_length < 16 {
        return encode_fixarray(data);
    } else if data_length < (1 << 16) {
        return encode_array16(data);
    } else if data_length < (1 << 32) {
        return encode_array32(data);
    } else {
        return error("array too large, not implemented");
    }
}

function encode_fixarray(json[] data) returns byte[]|error {
    byte[] output = [<byte>(0x90 + data.length())];
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

function encode_array16(json[] data) returns byte[]|error {
    byte[] output = [0xdc];
    byte[] length_in_bigendian_bytes = check core:toBytes(data.length(), 2);
    output.push(...length_in_bigendian_bytes);
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

function encode_array32(json[] data) returns byte[]|error {
    byte[] output = [0xdd];
    byte[] length_in_bigendian_bytes = check core:toBytes(data.length(), 4);
    output.push(...length_in_bigendian_bytes);
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}
