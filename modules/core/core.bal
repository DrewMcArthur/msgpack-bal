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
