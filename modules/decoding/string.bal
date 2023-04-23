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

function handleStr(byte[] data) returns string|error {
    var [length, offset] = check getStrLengthOffset(data);
    if length == 0 {
        return "";
    }
    // Get string bytes from input
    byte[] stringBytes = data.slice(offset, length + offset);
    // Convert bytes to string
    string output = checkpanic string:fromBytes(stringBytes);
    // Return string
    return output;
}

function getStrLengthOffset(byte[] data) returns [int, int]|error {
    match data[0] {
        var b if isFixStr(b) => {
            return [(b & 0x1f), 1];
        }
        0xd9 => {
            return [handleUint8(data), 2];
        }
        0xda => {
            return [handleUint16(data), 3];
        }
        0xdb => {
            return [handleUint32(data), 5];
        }
        _ => {
            return error(string `unknown string type 0x${data[0]}`);
        }
    }
}
