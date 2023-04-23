function isArray(byte first) returns boolean {
    return isFixArray(first) || isArray16(first) || isArray32(first);
}

function isFixArray(byte first) returns boolean {
    return (first & 0xf0) == 0x90;
}

function isArray16(byte first) returns boolean {
    return first == 0xdc;
}

function isArray32(byte first) returns boolean {
    return first == 0xdd;
}

function handleArray(byte first, byte[] data) returns [json[], byte[]]|error {
    int len;
    byte[] newdata = data;
    [len, newdata] = check getArrayLength(first, newdata);
    int i = 0;
    json[] out = [];
    json decoded;
    while i < len {
        [decoded, newdata] = check decodeShift(newdata);
        out.push(decoded);
        i = i + 1;
    }
    return [out, newdata];
}

function getArrayLength(byte first, byte[] data) returns [int, byte[]]|error {
    // return the length of the upcoming array
    if isFixArray(first) {
        return [first & 0x0f, data];
    }

    if isArray16(first) {
        return handleUintShift(data, 2);
    } else if isArray32(first) {
        return handleUintShift(data, 4);
    }

    return error(string `error getting array length: unsupported array: 0x${first}`);
}
