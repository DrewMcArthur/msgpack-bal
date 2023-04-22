import ballerina/io;

# encodes data of any type according to the msgpack spec
#
# + data - the data to be encoded
# + return - the encoded data an array of bytes
public function encode(json data) returns byte[]|error {
    io:println(`encoding ${data}`);
    if data is int {
        return encode_int(data);
    }
    if data is string {
        return encode_string(data);
    }
    if data is map<any> {
        return encode_map(data);
    }
    return error("input data is not of a supported type.");
}

# msgpack decoder: bytes -> variable
#
# + data - byte array encoded according to msgpack spec
# + return - deserialized data
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
    } else if isFixMap(first_byte) {
        return handleFixMap(data);
    } else if isMap16(first_byte) {
        return handleMap16(data);
    } else if isMap32(first_byte) {
        return handleMap32(data);
    }

    return error("not implemented");
}

////////////////////////
/// encoding helpers ///
////////////////////////
function encode_int(int n) returns byte[]|error {
    if n < -0x1f {
        return encode_signed_int(n);
    } else if n < 0 {
        return encode_negative_fixint(n);
    } else if n < 0x7f{
        return encode_positive_fixint(n);
    } else {
        return error("ints that large not implemented");
    }
}

function encode_signed_int(int n) returns error {
    return error("not implemented");
}

function encode_negative_fixint(int n) returns error {
    return error("not implemented");
}

function encode_positive_fixint(int n) returns byte[]|error {
    if n >= 0x80 {
        // todo: don't need this extra check
        return error("int too large for fixint");
    }
    return [<byte>n];
}

function encode_map(map<json> data) returns byte[]|error {
    io:println("encoding map");  
    int length = 0;
    byte[] output = [];
    foreach string key in data.keys() {
        length=length+1;
        byte[] encoded_key = check encode(key);
        output.push(...encoded_key);
        byte[] encoded_val = check encode(data[key]);
        output.push(...encoded_val);
    }
    int first_byte = 0x80+length;
    if first_byte > 0xff {
        return error("int overflow on length");
    }
    return [<byte>first_byte, ...output];
}

function encode_string(string data) returns byte[]|error {
    io:println("encoding string");
    var data_len = data.length();
    if data_len < 31 {
        return encode_short_str(data, data_len);
    }
    return error("string length > 31 bytes; unsupported");
}

function encode_short_str(string data, int len) returns byte[]|error {
    byte first_byte = check encode_short_str_first_byte(len);
    return [first_byte, ...data.toBytes()];
}

function encode_short_str_first_byte(int n) returns byte|error {
    if n < 0 {
        return error("length of string to encode cannot be less than 0");
    }
    if n > 31 {
        return error("length of short string to encode cannot be >31");
    }
    return <byte>(0xa0 + n);
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
    int length = getFixStrLength(first_byte) - 1;
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

function handleFixMap(byte[] data) returns map<json>|error {
    byte first_byte = data[0];
    int length = first_byte & 0x0f;
    if length == 0 {
        return {};
    }
    byte[] map_data = data.slice(1,data.length());
    map<json> result = {};
    foreach int i in 1...length {
        int key_length = check getItemLength(map_data);
        var key = check decode(map_data);
        map_data = map_data.slice(key_length,map_data.length());
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

function getItemLength(byte[] data) returns int|error {
    byte first_byte = data[0];
    if isPositiveFixInt(first_byte)
    {
        return 1;
    }
    if isFixStr(first_byte)
    {
        return getFixStrLength(first_byte);
    }
    return error("not implemented");
}

function handleMap16(byte[] data) returns map<json>|error {
    return error("not implemented");
}

function handleMap32(byte[] data) returns map<json>|error {
    return error("not implemented");
}

function getFixStrLength(byte b) returns int {
    return 1+(b & 0x1f);
}
