function encode_int(int n) returns byte[]|error {
    if n < -0x1f {
        return encode_signed_int(n);
    } else if n < 0 {
        return encode_negative_fixint(n);
    } else if n < 0x7f {
        return encode_positive_fixint(n);
    } else {
        return error("ints that large not implemented");
    }
}

function encode_signed_int(int n) returns error {
    return error("encode signed int not implemented");
}

function encode_negative_fixint(int n) returns error {
    return error("negative fixint not implemented");
}

function encode_positive_fixint(int n) returns byte[]|error {
    if n >= 0x80 {
        // todo: don't need this extra check
        return error("int too large for fixint");
    }
    return [<byte>n];
}
