import msgpack.core;

type FirstByteDetail record {
    string first_byte;
};

type BinDecodingError distinct error<FirstByteDetail>;

function isBin(byte first) returns boolean {
    return first == 0xc4 || first == 0xc5 || first == 0xc6;
}

function handleBin(byte first, byte[] data) returns [byte[], byte[]]|BinDecodingError {
    int length_length = 0; // the number of bytes used to determine array length
    match first {
        0xc4 => {
            length_length = 1;
        }
        0xc5 => {
            length_length = 2;
        }
        0xc6 => {
            length_length = 4;
        }
        _ => {
            return error BinDecodingError("Unexpected first byte, expected 0xc4, 0xc5, 0xc6", first_byte = first.toHexString());
        }
    }

    var [array_length, newdata] = handleUint(data, length_length);

    byte[] out = [];
    int i = 0;
    while i < array_length {
        i = i + 1;
        byte next;
        [next, newdata] = core:shift(newdata);
        out.push(next);
    }
    return [out, newdata];
}
