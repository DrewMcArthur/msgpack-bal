import ballerina/test;
import msgpack.core;

@test:Config {dataProvider: core:getTestCases}
function testEncodeCase(core:TestCase case) {
    var actual = encode(case.input);
    var expected = case.output;
    core:assertEqualsOrError(actual, expected);
}
