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

    byte[] first;
    if length < 16 {
        first = [<byte>(0x80 + length)];
    } else if length < 1 << 16 {
        byte[] lengthBytes = unsignedIntToBytes(length);
        while lengthBytes.length() < 2 {
            lengthBytes = [0x00, ...lengthBytes];
        }
        first = [0xde, ...lengthBytes];
    } else if length < 1 << 32 {
        byte[] lengthBytes = unsignedIntToBytes(length);
        while lengthBytes.length() < 4 {
            lengthBytes = [0x00, ...lengthBytes];
        }
        first = [0xde, ...lengthBytes];
    } else {
        return error("maps with length > 2^32 are not supported.");
    }

    return [...first, ...output];
}
