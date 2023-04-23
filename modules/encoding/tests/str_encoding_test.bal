import ballerina/test;
import msgpack.core;

@test:Config {}
function test_encode_short_str_first_byte()
{
    (byte|error)[] expectedResults = [
        0xa0,
        0xa1,
        0xa2,
        0xa3,
        0xa4,
        0xa5,
        0xa6,
        0xa7,
        0xa8,
        0xa9,
        0xaa,
        0xab,
        0xac,
        0xad,
        0xae,
        0xaf,
        0xb0,
        0xb1,
        0xb2,
        0xb3,
        0xb4,
        0xb5,
        0xb6,
        0xb7,
        0xb8,
        0xb9,
        0xba,
        0xbb,
        0xbc,
        0xbd,
        0xbe,
        0xbf,
        error("length of short string to encode cannot be >31"),
        error("length of short string to encode cannot be >31"),
        error("length of short string to encode cannot be >31")
    ];

    foreach int i in 0 ... 31 {
        byte|error actual = encode_short_str_first_byte(i);
        byte|error expected = expectedResults[i];
        core:assertEqualsOrError(actual, expected);
    }
}
