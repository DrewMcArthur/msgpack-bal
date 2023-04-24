import msgpack.core;
import ballerina/test;

type StrTestCase record {
    byte[] input;
    int output;
};

@test:Config {dataProvider: getStrTestCases}
function testStrLengthOffset(StrTestCase case) returns error? {
    int len;
    var [first, newdata] = core:shift(case.input);
    [len, newdata] = check getStrLength(first, newdata);
    core:assertEqualsOrError(len, case.output);
}

function getStrTestCases() returns StrTestCase[][] {
    return [
        [{"input": [0xa0], "output": 0}],
        [{"input": [0xa1], "output": 1}],
        [{"input": [0xbf], "output": 31}],
        [{"input": [0xd9, 0x20], "output": 0x20}],
        [{"input": [0xd9, 0xff], "output": 0xff}],
        [{"input": [0xda, 0x01, 0x00], "output": 256}],
        [{"input": [0xda, 0xff, 0xff], "output": 65535}],
        [{"input": [0xdb, 0xff, 0xff, 0xff, 0xff], "output": 4294967295}]
    ];
}
