import msgpack.encoding;
import msgpack.decoding;

# encodes data of any type according to the msgpack spec
#
# + data - the data to be encoded
# + return - the encoded data an array of bytes
public function encode(json data) returns byte[]|encoding:EncodingError {
    return encoding:encode(data);
}

# msgpack decoder: bytes -> variable
#
# + data - byte array encoded according to msgpack spec
# + return - deserialized data
public function decode(byte[] data) returns json|decoding:DecodingError {
    return decoding:decode(data);
}
