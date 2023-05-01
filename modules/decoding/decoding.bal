import msgpack.core;

public function decode(byte[] data) returns json|DecodingError {
    var [output, leftover] = check decodeShift(data);
    if leftover.length() > 0 {
        return error LeftoverDecodingError("invalid encoding, did not expect leftover data after decoding", leftover = leftover);
    }
    return output;
}

function decodeShift(byte[] data) returns [json, byte[]]|DecodingError {
    if data.length() == 0 {
        return error EmptyDataDecodingError("empty input");
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
    if isBin(first) {
        return handleBin(first, newdata);
    }

    return error ShiftDecodingError("decoding type unknown: not implemented", first_byte = first);
}

/// returns total number of bytes 
function getItemLength(byte[] data) returns [int, byte[]]|LengthError {
    var [first, newdata] = core:shift(data);
    if isPositiveFixInt(first) {
        return [1, newdata];
    }
    if isStr(first) {
        int length;
        [length, newdata] = check getStrLength(first, data);
        return [1 + length, newdata];
    }
    return error ItemLengthError(string `item length not implemented for 0x${first.toHexString()}`);
}

public type DecodingError LeftoverDecodingError|ShiftDecodingError|IntDecodingError|BinDecodingError|ArrayDecodingError|MapDecodingError|LengthError|EmptyDataDecodingError;

type LeftoverDecodingError distinct error<record {byte[] leftover;}>;

type ShiftDecodingError distinct error<record {byte first_byte;}>;

type ItemLengthError (distinct error);

type LengthError ItemLengthError|StrLengthError;

type EmptyDataDecodingError distinct error;
