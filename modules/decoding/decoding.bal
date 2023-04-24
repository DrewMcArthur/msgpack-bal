import msgpack.core;

public function decode(byte[] data) returns json|error {
    var [output, leftover] = check decodeShift(data);
    if leftover.length() > 0 {
        return error("invalid encoding, did not expect leftover data after decoding");
    }
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
        return handleInt(first, newdata);
    }
    if isStr(first) {
        return handleStr(first, newdata);
    }
    if isArray(first) {
        return handleArray(first, newdata);
    }
    if isMap(first) {
        return handleMap(first, newdata);
    }

    return error("decoding type unknown: not implemented");
}

/// returns total number of bytes 
function getItemLength(byte[] data) returns [int, byte[]]|error {
    var [first, newdata] = core:shift(data);
    if isPositiveFixInt(first) {
        return [1, newdata];
    }
    if isStr(first) {
        int length;
        [length, newdata] = check getStrLength(first, data);
        return [1 + length, newdata];
    }
    return error(string `item length not implemented for 0x${first.toHexString()}`);
}
