import msgpack.core;

public function decode(byte[] data) returns json|error {
    var [output, _] = check decodeShift(data);
    return output;
}

function decodeShift(byte[] data) returns [json, byte[]]|error {
    if data.length() == 0 {
        return error("empty input");
    }

    byte first;
    byte[] newdata;
    [first, newdata] = core:shift(data);
    if first == 0xc0 {
        return [(), newdata];
    }
    if first == 0xc2 {
        return [false, newdata];
    }
    if first == 0xc3 {
        return [true, newdata];
    }
    if isInt(first) {
        return [check handleInt(data), newdata];
    }
    if isStr(first) {
        return [check handleStr(data), newdata];
    }
    if isArray(first) {
        return handleArray(first, data);
    }
    if isFixMap(first) {
        return [check handleFixMap(data), newdata];
    }
    if isMap16(first) {
        return [check handleMap16(data), newdata];
    }
    if isMap32(first) {
        return [check handleMap32(data), newdata];
    }

    return error("decoding type unknown: not implemented");
}

/// returns total number of bytes 
function getItemLength(byte[] data) returns int|error {
    byte first_byte = data[0];
    if isPositiveFixInt(first_byte) {
        return 1;
    }
    if isStr(first_byte) {
        var [length, _] = check getStrLengthOffset(data);
        return 1 + length;
    }
    return error(string `item length not implemented for 0x${first_byte.toHexString()}`);
}

function getFixArrayLength(byte b) returns int {
    return (b & 0x0f);
}
