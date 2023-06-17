import ballerina/test;
import msgpack.core;

@test:Config {dataProvider: core:getTestCases}
function testDecodeCase(core:TestCase case) {
    byte[] data = case.output.clone();
    var actual = decode(data);
    test:assertEquals(actual, case.input);
}
