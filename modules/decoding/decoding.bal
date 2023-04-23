public function decode(byte[] data) returns json|error {
    if data.length() == 0 {
        return error("empty input");
    }

    byte first = data[0];
    if first == 0xc0 {
        return ();
    }
    if first == 0xc2 {
        return false;
    }
    if first == 0xc3 {
        return true;
    }
    if isInt(first) {
        return handleInt(data);
    }
    if isFixStr(first) {
        return handleFixStr(data);
    }
    if isStr8(first) {
        return handleStr8(data);
    }
    if isFixArray(first) {
        return handleFixArray(data);
    }
    if isFixMap(first) {
        return handleFixMap(data);
    }
    if isMap16(first) {
        return handleMap16(data);
    }
    if isMap32(first) {
        return handleMap32(data);
    }

    return error("decoding type unknown: not implemented");
}

/// returns total number of bytes 
function getItemLength(byte[] data) returns int|error {
    byte first_byte = data[0];
    if isPositiveFixInt(first_byte) {
        return 1;
    }
    if isFixStr(first_byte) {
        return 1 + getFixStrLength(first_byte);
    }
    return error(string `item length not implemented for 0x${first_byte.toHexString()}`);
}

function getFixArrayLength(byte b) returns int {
    return (b & 0x0f);
}
