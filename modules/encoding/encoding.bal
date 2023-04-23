public function encode(json data) returns byte[]|error {
    if data is int {
        return encode_int(data);
    }
    if data is string {
        return encode_string(data);
    }
    if data is json[] {
        return encode_array(data);
    }
    if data is map<any> {
        return encode_map(data);
    }
    return error("input data is not of a supported type.");
}
