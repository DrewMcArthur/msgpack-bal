import ballerina/test;

@test:Config {}
function testAssertEqualsOrError() {
    var actual = error("e1");
    var expected = error("e1");
    assertEqualsOrError(actual, expected, "should be equal");
}
