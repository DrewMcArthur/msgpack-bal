// returns true if byte b signifies an item in the int format family
import msgpack.core;

function isInt(byte b) returns boolean {
    return isPositiveFixInt(b) || isNegativeFixInt(b) || (b > 0xcb && b < 0xd4);
}

type IntChecker function (byte) returns boolean;

type IntHandler function (byte[]) returns int|error;

class IntFormatType {
    IntChecker checker;
    IntHandler handler;
    function init(IntChecker checker, IntHandler handler) {
        self.checker = checker;
        self.handler = handler;
    }
}

function getIntFormatTypes() returns IntFormatType[] {
    return [
        new IntFormatType(checker = isPositiveFixInt, handler = handlePositiveFixInt),
        new IntFormatType(checker = isNegativeFixInt, handler = handleNegativeFixInt),
        new IntFormatType(checker = isUint8, handler = handleUint8),
        new IntFormatType(checker = isUint16, handler = handleUint16),
        new IntFormatType(checker = isUint32, handler = handleUint32),
        new IntFormatType(checker = isUint64, handler = handleUint64),
        new IntFormatType(checker = isInt8, handler = handleInt8),
        new IntFormatType(checker = isInt16, handler = handleInt16),
        new IntFormatType(checker = isInt32, handler = handleInt32),
        new IntFormatType(checker = isInt64, handler = handleInt64)
    ];
}

function handleInt(byte[] data) returns int|error {
    byte first = data[0];
    foreach IntFormatType fmt in getIntFormatTypes() {
        if fmt.checker(first) {
            return fmt.handler(data);
        }
    }

    return error(string `not a known int ${first}`);
}

////////////////
/// checkers ///
////////////////
function isPositiveFixInt(byte b) returns boolean {
    return (b & 0x80) == 0x00;
}

function isNegativeFixInt(byte b) returns boolean {
    return (b & 0xe0) == 0xe0;
}

function isUint8(byte b) returns boolean {
    return b == 0xcc;
}

function isUint16(byte b) returns boolean {
    return b == 0xcd;
}

function isUint32(byte b) returns boolean {
    return b == 0xce;
}

function isUint64(byte b) returns boolean {
    return b == 0xcf;
}

function isInt8(byte b) returns boolean {
    return b == 0xd0;
}

function isInt16(byte b) returns boolean {
    return b == 0xd1;
}

function isInt32(byte b) returns boolean {
    return b == 0xd2;
}

function isInt64(byte b) returns boolean {
    return b == 0xd3;
}

////////////////
/// handlers ///
////////////////
function handlePositiveFixInt(byte[] data) returns int {
    return <int>data[0];
}

function handleNegativeFixInt(byte[] data) returns int {
    return <int>(data[0] & 0x1f) - 32;
}

function handleUint(byte[] data, int nBytes) returns int {
    int out = 0;
    foreach int i in 1 ... nBytes {
        out = (out << 8) | data[i];
    }
    return out;
}

// takes in an array of bytes
// pops off the number of bytes specified
// returns [a big-endian int, the remainder of the data]
function handleUintShift(byte[] data, int nBytes) returns [int, byte[]] {
    int out = 0;
    int i = 0;
    byte[] newdata = data;
    byte next;
    while i < nBytes {
        [next, newdata] = core:shift(newdata);
        out = (out << 8) | next;
    }
    return [out, newdata];
}

function handleUint8(byte[] data) returns int {
    return handleUint(data, 1);
}

function handleUint16(byte[] data) returns int {
    return handleUint(data, 2);
}

function handleUint32(byte[] data) returns int {
    return handleUint(data, 4);
}

function handleUint64(byte[] data) returns int {
    return handleUint(data, 8);
}

function handleSignedInt(byte[] data, int nBytes) returns int|error {
    int out = 0;
    foreach int i in 1 ... nBytes {
        out = (out << 8) | data[i];
    }

    if nBytes == 8 {
        // hacky workaround, since 1 << 64 -> 1 bc 64-bit ints
        return error("decoding signed Int64 types is not currently supported, sorry!");
    }
    return out - (1 << (8 * nBytes));
}

function handleInt8(byte[] data) returns int|error {
    return handleSignedInt(data, 1);
}

function handleInt16(byte[] data) returns int|error {
    return handleSignedInt(data, 2);
}

function handleInt32(byte[] data) returns int|error {
    return handleSignedInt(data, 4);
}

function handleInt64(byte[] data) returns int|error {
    return handleSignedInt(data, 8);
}
