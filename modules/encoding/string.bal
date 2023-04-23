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
