function isMap(byte b) returns boolean {
    return isFixMap(b) || isMap16(b) || isMap32(b);
}

function handleMap(byte first, byte[] data) returns [map<json>, byte[]]|DecodingError {
    int len;
    byte[] newdata;
    [len, newdata] = check getMapLength(first, data);

    map<json> out = {};
    int i = 0;
    json key;
    json val;
    while i < len {
        i = i + 1;
        [key, newdata] = check decodeShift(newdata);
        [val, newdata] = check decodeShift(newdata);
        if !(key is string) {
            return error MapDecodingError(string `expected key is string but key at index ${i} is ${key.toString()}`, first_byte = first);
        }
        out[key] = val;
    }
    return [out, newdata];
}

function getMapLength(byte first, byte[] data) returns [int, byte[]]|MapDecodingError {
    if isFixMap(first) {
        return [first & 0x0f, data];
    }

    match first {
        0xde => {
            return handleUint(data, 2);
        }
        0xdf => {
            return handleUint(data, 4);
        }
    }

    return error MapDecodingError(string `unsupported map 0x${first}`, first_byte = first);
}

function isFixMap(byte b) returns boolean {
    return (b & 0xf0) == 0x80;
}

function isMap16(byte b) returns boolean {
    return b == 0xde;
}

function isMap32(byte b) returns boolean {
    return b == 0xdf;
}

type MapDecodingError distinct error<record {byte first_byte;}>;
