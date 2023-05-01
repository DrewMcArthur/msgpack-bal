public function encode(json data) returns byte[]|EncodingError {
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
    return error TypeEncodingError("input data is not of a supported type.", t = (typeof data));
}

type TypeEncodingError distinct error<record {typedesc t;}>;

public type EncodingError TypeEncodingError|IntEncodingError|StringEncodingError|ArrayEncodingError|BinEncodingError|ArrayEncodingError|MapEncodingError;
