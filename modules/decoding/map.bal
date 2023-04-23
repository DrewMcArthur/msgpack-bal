function isFixMap(byte b) returns boolean {
    return (b & 0xf0) == 0x80;
}

function isMap16(byte b) returns boolean {
    return b == 0xde;
}

function isMap32(byte b) returns boolean {
    return b == 0xdf;
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

function handleMap16(byte[] data) returns map<json>|error {
    return error("map16 not implemented");
}

function handleMap32(byte[] data) returns map<json>|error {
    return error("map32 not implemented");
}
