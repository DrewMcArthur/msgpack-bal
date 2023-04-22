import ballerina/io;
import ballerina/test;

type TestCase record {
    json input;
    byte[]|error output;
};

function getTestCases() returns TestCase[][] {
    return [
          [{"input": "", "output": [0xa0]}]
        , [{"input": "A", "output": [0xa1, 0x41]}]
        , [{"input": "ab", "output": [0xa2, 0x61, 0x62]}]
        , [{
            "input": "short string, under 31 bytes!",
            "output": [
                0xbd, 0x73, 0x68, 0x6f, 0x72, 0x74, 0x20, 0x73, 0x74, 0x72,
                0x69, 0x6e, 0x67, 0x2c, 0x20, 0x75, 0x6e, 0x64, 0x65, 0x72,
                0x20, 0x33, 0x31, 0x20, 0x62, 0x79, 0x74, 0x65, 0x73, 0x21
            ]
        } ]
        , [{"input": {}, "output": [0x80]}]
        , [{"input": [], "output": [0x90]}]
        , [{"input": [0], "output": [0x91, 0x00]}]
        , [{
            "input": {"a": "b"},
            "output": [0x81,0xa1,0x61,0xa1,0x62]
        }]
        , [{
            "input": {"id": 0},
            "output": [0x81,0xa2,0x69,0x64,0x00]
        }]
    ];
}

// function getTestCaseMap() returns map<[TestCase]> {
//     map<[TestCase]> result = {};
//     foreach TestCase case in getTestCases()
//     {
//         result[<string>case.input] = [case];
//     }
//     return result;
// }

// Before Suite Function

@test:BeforeSuite
function beforeSuiteFunc() {
    io:println("I'm the before suite function!");
}

// Test function

@test:Config {dataProvider: getTestCases}
function testEncodeCase(TestCase case) {
    io:println(`encoding: ${case}`);
    var actual = encode(case.input);
    var expected = case.output;
    assertEqualsOrError(actual, expected);
}

@test:Config {dataProvider: getTestCases}
function testDecodeCase(TestCase case) {
    io:println(`decoding: ${case}`);
    byte[]|error data = case.output.clone();
    if data is error {
        test:assertTrue(true, "cannot test decoding an error message");
    }
    else {
        var actual = decode(data);
        test:assertEquals(actual, case.input);
    }
}

// After Suite Function

@test:AfterSuite
function afterSuiteFunc() {
    io:println("I'm the after suite function!");
}

public function assertEqualsOrError(anydata|error actual, anydata|error expected, string msg = "")
{
    if expected is error {
        test:assertTrue(actual is error, "expected an error, but succeeded");
        var actual_error_msg = (<error>actual).message();
        test:assertEquals(actual_error_msg, expected.message());
    } else {
        test:assertEquals(actual, expected);
    }
}
