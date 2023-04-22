import ballerina/test;
import msgpack.core;

@test:Config {dataProvider: core:getTestCases}
function testDecodeCase(core:TestCase case) {
    byte[]|error data = case.output.clone();
    if data is error {
        test:assertTrue(true, "cannot test decoding an error message");
    }
    else {
        var actual = decode(data);
        test:assertEquals(actual, case.input);
    }
}
