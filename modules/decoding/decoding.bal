public function decode(byte[] data) returns json|error {
    if data.length() == 0 {
        return error("empty input");
    }

    var first_byte = data[0];
    if isPositiveFixInt(first_byte) {
        return handlePositiveFixInt(data);
    } else if isFixStr(first_byte) {
        return handleFixStr(data);
    } else if isStr8(first_byte) {
        return handleStr8(data);
    } else if isFixArray(first_byte) {
        return handleFixArray(data);
    } else if isFixMap(first_byte) {
        return handleFixMap(data);
    } else if isMap16(first_byte) {
        return handleMap16(data);
    } else if isMap32(first_byte) {
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
