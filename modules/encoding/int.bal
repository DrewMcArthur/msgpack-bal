function encodeInt(int n) returns byte[]|error {
    if n < -32 {
        return encodeSignedInt(n);
    }
    if n < 0 {
        return encodeNegativeFixint(n);
    }
    return check encodeUnsignedInt(n);
}

function encodeSignedInt(int n) returns byte[]|error {
    byte[] intBytes = signedIntToBytes(n);
    byte first;

    if n <= -(32768*32768) {
        first = 0xd3;
        intBytes = padBytesLeft(intBytes, 8);
    } else if n <= -32768 {
        first = 0xd2;
        intBytes = padBytesLeft(intBytes, 4);
    } else if n <= -128 {
        first = 0xd1;
        intBytes = padBytesLeft(intBytes, 2);
    } else if n <= -32 {
        first = 0xd0;
    } else {
        return error("wrong handler for negativefixint");
    }
    return [first, ...intBytes.reverse()];
}

function encodeNegativeFixint(int n) returns byte[] {
    return [<byte>(0xe0 ^ (n + 32))];
}

function unsignedIntToBytes(int n) returns byte[] {
    if n == 0 {
        return [0x00];
    }

    byte[] out = [];
    int remaining = n;
    while remaining > 0 {
        out.push(<byte>(remaining & 0xff));
        remaining = remaining >> 8;
    }
    return out.reverse();
}

function signedIntToBytes(int n) returns byte[] {
    byte[] out = [];
    int remaining = -n - 1;
    while remaining > 0 {
        out.push(<byte>(0xff - (remaining & 0xff)));
        remaining = remaining >> 8;
    }
    return out;
}

function encodeUnsignedInt(int n) returns byte[]|error {
    byte[] uintBytes = unsignedIntToBytes(n);
    if uintBytes.length() == 1 {
        if (uintBytes[0] & 0x80) == 0 {
            return uintBytes;
        }
        return [0xcc, ...uintBytes];
    }
    if uintBytes.length() == 2 {
        return [0xcd, ...uintBytes];
    }
    if uintBytes.length() == 3 {
        return [0xce, 0x00, ...uintBytes];
    }
    if uintBytes.length() == 4 {
        return [0xce, ...uintBytes];
    }
    if uintBytes.length() == 5 {
        return [0xcf, 0x00, 0x00, 0x00, ...uintBytes];
    }
    if uintBytes.length() == 6 {
        return [0xcf, 0x00, 0x00, ...uintBytes];
    }
    if uintBytes.length() == 7 {
        return [0xcf, 0x00, ...uintBytes];
    }
    if uintBytes.length() == 8 {
        return [0xcf, ...uintBytes];
    }
    return error("unknown int type");
}

function padBytesLeft(byte[] bytes, int desiredLength) returns byte[] {
    while bytes.length() < desiredLength {
        bytes.push(0xff);
    }
    return bytes;
}
