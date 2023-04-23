import msgpack.core;
import ballerina/test;

type StrTestCase record {
    byte[] input;
    [int, int] output;
};

@test:Config {dataProvider: getStrTestCases}
function testStrLengthOffset(StrTestCase case) {
    var output = getStrLengthOffset(case.input);
    core:assertEqualsOrError(output, case.output);
}

function getStrTestCases() returns StrTestCase[][] {
    return [
        [{"input": [0xa0], "output": [0, 1]}],
        [{"input": [0xa1], "output": [1, 1]}],
        [{"input": [0xbf], "output": [31, 1]}],
        [{"input": [0xd9, 0x20], "output": [0x20, 2]}],
        [{"input": [0xd9, 0xff], "output": [0xff, 2]}],
        [{"input": [0xda, 0x01, 0x00], "output": [256, 3]}],
        [{"input": [0xda, 0xff, 0xff], "output": [65535, 3]}],
        [{"input": [0xdb, 0xff, 0xff, 0xff, 0xff], "output": [4294967295, 5]}]
    ];
}
