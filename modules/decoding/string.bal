function isStr(byte b) returns boolean {
    return isFixStr(b) || isStr8(b) || isStr16(b) || isStr32(b);
}

function isFixStr(byte b) returns boolean {
    return (b & 0xe0) == 0xa0;
}

function isStr8(byte b) returns boolean {
    return b == 0xd9;
}

function isStr16(byte b) returns boolean {
    return b == 0xda;
}

function isStr32(byte b) returns boolean {
    return b == 0xdb;
}

function handleStr(byte first, byte[] data) returns [string, byte[]]|StrLengthError {
    var [length, newdata] = check getStrLength(first, data);
    if length == 0 {
        return ["", newdata];
    }
    byte[] stringBytes = newdata.slice(0, length);
    string output = checkpanic string:fromBytes(stringBytes);
    return [output, newdata.slice(length)];
}

function getStrLength(byte first, byte[] data) returns [int, byte[]]|StrLengthError {
    // technically these don't need to be set, but the compiler thinks they should be
    match first {
        var b if isFixStr(b) => {
            return [(b & 0x1f), data];
        }
        0xd9 => {
            return handleUint8(first, data);
        }
        0xda => {
            return handleUint16(first, data);
        }
        0xdb => {
            return handleUint32(first, data);
        }
        _ => {
            return error StrLengthError(string `unknown string type 0x${data[0]}`, first_byte = data[0]);
        }
    }
}

type StrLengthError distinct error<record {byte first_byte;}>;
