public function encode(json|byte[] data) returns byte[]|error {
    if data is null {
        return [0xc0];
    }
    if data is false {
        return [0xc2];
    }
    if data is true {
        return [0xc3];
    }
    if data is int {
        return encodeInt(data);
    }
    if data is string {
        return encode_string(data);
    }
    if data is byte[] {
        return encode_bin(data);
    }
    if data is json[] {
        return encode_array(data);
    }
    if data is map<any> {
        return encode_map(data);
    }
    return error("input data is not of a supported type.");
}
