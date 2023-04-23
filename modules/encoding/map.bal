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
