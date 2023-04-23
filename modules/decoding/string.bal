
function isFixStr(byte b) returns boolean {
    return (b & 0xe0) == 0xa0;
}

function isStr8(byte b) returns boolean {
    return b == 0xd9 || b == 0xda || b == 0xdb;
}

function handleFixStr(byte[] data) returns string {
    byte first_byte = data[0];
    // String with length less than 32
    // Get length from last three bits
    int length = getFixStrLength(first_byte);
    // Get string bytes from input
    byte[] stringBytes = data.slice(1, length + 1);
    // Convert bytes to string
    string output = checkpanic string:fromBytes(stringBytes);
    // Return string
    return output;
}

function handleStr8(byte[] data) returns string {
    byte first_byte = data[0];
    // String with length 32 or more
    // Get length from next bytes depending on prefix
    int length = 0;
    int offset = 0;
    if first_byte == 0xd9 {
        // Length fits in 8 bits
        length = data[1];
        offset = 2;
    } else if first_byte == 0xda {
        // Length fits in 16 bits
        length = (data[1] << 8) | data[2];
        offset = 3;
    } else if first_byte == 0xdb {
        // Length fits in 32 bits
        length = (data[1] << 24) | (data[2] << 16) | (data[3] << 8) | data[4];
        offset = 5;
    }
    // Get string bytes from input
    byte[] stringBytes = data.slice(offset, offset + length);
    // Convert bytes to string
    string output = checkpanic string:fromBytes(stringBytes);
    // Return string
    return output;
}

function getFixStrLength(byte b) returns int {
    return (b & 0x1f);
}
