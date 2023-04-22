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

///////////////////////////////
/// msgpack format checkers ///
///////////////////////////////
function isPositiveFixInt(byte b) returns boolean {
    return (b & 0x80) == 0x00;
}

function isFixStr(byte b) returns boolean {
    return (b & 0xe0) == 0xa0;
}

function isStr8(byte b) returns boolean {
    return b == 0xd9 || b == 0xda || b == 0xdb;
}

function isFixArray(byte firstByte) returns boolean {
    return (firstByte & 0xf0) == 0x90;
}

function isFixMap(byte b) returns boolean {
    return (b & 0xf0) == 0x80;
}

function isMap16(byte b) returns boolean {
    return b == 0xde;
}

function isMap32(byte b) returns boolean {
    return b == 0xdf;
}

///////////////////////////////
/// msgpack format handlers ///
///////////////////////////////
function handlePositiveFixInt(byte[] data) returns int {
    return <int>data[0];
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

function handleFixArray(byte[] data) returns json[]|error {
    int array_length = data[0] & 0x0f;
    json[] output = [];
    byte[] array_data = data.slice(1, data.length());
    foreach int i in 1 ... array_length {
        int item_length = check getItemLength(array_data);
        // todo: this won't work for nested arrays, we need to pop off somehow.
        output.push(check decode(array_data));
        array_data = array_data.slice(item_length, array_data.length());
    }
    return output;
}

function handleFixMap(byte[] data) returns map<json>|error {
    byte first_byte = data[0];
    int length = first_byte & 0x0f;
    if length == 0 {
        return {};
    }
    byte[] map_data = data.slice(1, data.length());
    map<json> result = {};
    foreach int i in 1 ... length {
        int key_length = check getItemLength(map_data);
        var key = check decode(map_data);
        map_data = map_data.slice(key_length, map_data.length());
        int val_length = check getItemLength(map_data);
        var val = check decode(map_data);
        map_data = map_data.slice(val_length, map_data.length());
        if !(key is string) {
            return error("expected map key to be string");
        }
        result[key] = val;
    }
    return result;
}

/// returns total number of bytes 
function getItemLength(byte[] data) returns int|error {
    byte first_byte = data[0];
    // if isFixArray(first_byte) {
    //     return 1+getFixArrayLength(first_byte);
    // }
    if isPositiveFixInt(first_byte) {
        return 1;
    }
    if isFixStr(first_byte) {
        return 1 + getFixStrLength(first_byte);
    }
    return error(string `item length not implemented for 0x${first_byte.toHexString()}`);
}

function handleMap16(byte[] data) returns map<json>|error {
    return error("map16 not implemented");
}

function handleMap32(byte[] data) returns map<json>|error {
    return error("map32 not implemented");
}

function getFixStrLength(byte b) returns int {
    return (b & 0x1f);
}

function getFixArrayLength(byte b) returns int {
    return (b & 0x0f);
}
