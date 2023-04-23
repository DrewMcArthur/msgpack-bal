import ballerina/test;

# function that allows expected to be an error (test:assertEquals doesn't allow this)
# params generally same as 
# + actual - Parameter Description  
# + expected - Parameter Description  
# + msg - Parameter Description
public function assertEqualsOrError(anydata|error actual, anydata|error expected, string msg = "")
{
    if expected is error {
        test:assertTrue(actual is error, "expected an error, but succeeded: " + msg);
        string actual_error_msg = (<error>actual).message();
        test:assertEquals(actual_error_msg, expected.message(), msg);
    } else {
        test:assertEquals(actual, expected, msg);
    }
}

public type TestCase record {
    json input;
    byte[]|error output;
};

public function getTestCases() returns TestCase[][] {
    return [
        [{"input": null, "output": [0xc0]}],
        [{"input": false, "output": [0xc2]}],
        [{"input": true, "output": [0xc3]}],
        [{"input": 0, "output": [0x00]}],
        [{"input": 1, "output": [0x01]}],
        [{"input": 127, "output": [0x7f]}],
        [{"input": -1, "output": [0xff]}],
        [{"input": -32, "output": [0xe0]}],
        [{"input": 128, "output": [0xcc, 0x80]}],
        [{"input": 255, "output": [0xcc, 0xff]}],
        [{"input": 256, "output": [0xcd, 0x01, 0x00]}],
        [{"input": 65535, "output": [0xcd, 0xff, 0xff]}],
        [{"input": 65536, "output": [0xce, 0x00, 0x01, 0x00, 0x00]}],
        [{"input": 65537, "output": [0xce, 0x00, 0x01, 0x00, 0x01]}],
        [{"input": 11111111111, "output": [0xcf, 0x00, 0x00, 0x00, 0x02, 0x96, 0x46, 0x19, 0xc7]}],
        [{"input": 1111111111111111168, "output": [0xcf, 0x0f, 0x6b, 0x75, 0xab, 0x2b, 0xc4, 0x72, 0x00]}],
        [{"input": -33, "output": [0xd0, 0xdf]}],
        [{"input": -40, "output": [0xd0, 0xd8]}],
        [{"input": -127, "output": [0xd0, 0x81]}],
        [{"input": -128, "output": [0xd1, 0xff, 0x80]}],
        [{"input": -405, "output": [0xd1, 0xfe, 0x6b]}],
        [{"input": -32767, "output": [0xd1, 0x80, 0x01]}],
        [{"input": -32768, "output": [0xd2, 0xff, 0xff, 0x80, 0x00]}],
        [{"input": -32769, "output": [0xd2, 0xff, 0xff, 0x7f, 0xff]}],
        [{"input": -11111111111, "output": [0xd3, 0xff, 0xff, 0xff, 0xfd, 0x69, 0xb9, 0xe6, 0x39]}],
        [{"input": "", "output": [0xa0]}],
        [{"input": "A", "output": [0xa1, 0x41]}],
        [{"input": "ab", "output": [0xa2, 0x61, 0x62]}],
        [
            {
                "input": "short string, under 31 bytes!",
                "output": [
                    0xbd,
                    0x73,
                    0x68,
                    0x6f,
                    0x72,
                    0x74,
                    0x20,
                    0x73,
                    0x74,
                    0x72,
                    0x69,
                    0x6e,
                    0x67,
                    0x2c,
                    0x20,
                    0x75,
                    0x6e,
                    0x64,
                    0x65,
                    0x72,
                    0x20,
                    0x33,
                    0x31,
                    0x20,
                    0x62,
                    0x79,
                    0x74,
                    0x65,
                    0x73,
                    0x21
                ]
            }
        ],
        [{"input": {}, "output": [0x80]}],
        [{"input": [], "output": [0x90]}],
        [{"input": [0], "output": [0x91, 0x00]}],
        [
            {
                "input": {"a": "b"},
                "output": [0x81, 0xa1, 0x61, 0xa1, 0x62]
            }
        ],
        [
            {
                "input": {"id": 0},
                "output": [0x81, 0xa2, 0x69, 0x64, 0x00]
            }
        ]
    ];
}

public function getTestCaseMap() returns map<TestCase[]> {
    map<TestCase[]> result = {};
    foreach TestCase[] case in getTestCases()
    {
        result[<string>case[0].input] = case;
    }
    return result;
}

public function padStr(int size, string value, string padChar = " ", boolean left = true) returns string {
    int diff = size - value.length();
    if (diff < 1) {
        return value;
    }

    string padding = "";
    while (diff > 0) {
        padding += padChar;
        diff -= 1;
    }

    if left {
        return padding + value;
    } else {
        return value + padding;
    }
}

public function padNum(int size, int|float num) returns string {
    string value = num.toString();
    return padStr(size, value, " ");
}

# converts an int to a byte[]
#
# + num - the number to convert
# + minArraySize - the minimum size of the byte array to return
# + endianness - Parameter Description  
# + signed - specify if a positive num should be returned as a signed uint.  
# negative numbers are always signed
# + return - a byte array corresponding to the input number according to settings
public function toBytes(
        int num, int minArraySize = 0,
        boolean endianness = true,
        boolean signed = false
) returns byte[]|error {
    byte[] bytes = [];
    int numLeft = num;

    if num == 0 {
        bytes = [0x00];
    }

    // Loop through the byte array and assign the shifted bits of the int value
    while numLeft > 0 {
        byte currentByte = <byte>(numLeft % 256);
        numLeft = numLeft / 256;
        bytes.push(currentByte);
    }

    while bytes.length() < minArraySize {
        bytes.push(0x00);
    }

    if endianness {
        return bytes.reverse();
    } else {
        return bytes;
    }
}
