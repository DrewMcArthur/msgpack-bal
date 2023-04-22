public function encode(json data) returns byte[]|error {
    if data is int {
        return encode_int(data);
    }
    if data is string {
        return encode_string(data);
    }
    if data is json[] {
        return encode_array(data);
    }
    if data is map<any> {
        return encode_map(data);
    }
    return error("input data is not of a supported type.");
}

function encode_int(int n) returns byte[]|error {
    if n < -0x1f {
        return encode_signed_int(n);
    } else if n < 0 {
        return encode_negative_fixint(n);
    } else if n < 0x7f {
        return encode_positive_fixint(n);
    } else {
        return error("ints that large not implemented");
    }
}

function encode_signed_int(int n) returns error {
    return error("encode signed int not implemented");
}

function encode_negative_fixint(int n) returns error {
    return error("negative fixint not implemented");
}

function encode_positive_fixint(int n) returns byte[]|error {
    if n >= 0x80 {
        // todo: don't need this extra check
        return error("int too large for fixint");
    }
    return [<byte>n];
}

function encode_array(json[] data) returns byte[]|error {
    int data_length = data.length();
    if data_length < 16 {
        return encode_fixarray(data);
    } else if data_length < 0xFF {
        return encode_array16(data);
    } else {
        // if data_length < [0xff, 0xff]
        // technically supported, todo
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
    byte[] length_in_bigendian_bytes = check toBigEndian(data.length());
    output.push(...length_in_bigendian_bytes);
    foreach json item in data {
        var encoded_item = check encode(item);
        output.push(...encoded_item);
    }
    return output;
}

function toBigEndian(int n) returns byte[]|error {
    return error("creating big endian bytearray from an int not yet implemented");
}

function encode_map(map<json> data) returns byte[]|error {
    int length = 0;
    byte[] output = [];
    foreach string key in data.keys() {
        length = length + 1;
        byte[] encoded_key = check encode(key);
        output.push(...encoded_key);
        byte[] encoded_val = check encode(data[key]);
        output.push(...encoded_val);
    }
    int first_byte = 0x80 + length;
    if first_byte > 0xff {
        return error("int overflow on length");
    }
    return [<byte>first_byte, ...output];
}

function encode_string(string data) returns byte[]|error {
    var data_len = data.length();
    if data_len < 31 {
        return encode_short_str(data, data_len);
    }
    return error("string length > 31 bytes; unsupported");
}

function encode_short_str(string data, int len) returns byte[]|error {
    byte first_byte = check encode_short_str_first_byte(len);
    return [first_byte, ...data.toBytes()];
}

function encode_short_str_first_byte(int n) returns byte|error {
    if n < 0 {
        return error("length of string to encode cannot be less than 0");
    }
    if n > 31 {
        return error("length of short string to encode cannot be >31");
    }
    return <byte>(0xa0 + n);
}
