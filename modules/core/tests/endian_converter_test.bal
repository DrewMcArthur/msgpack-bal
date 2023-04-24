import ballerina/test;

function getEndianConverterTestValues() returns (int|byte[]|boolean)[][] {
    return [
        [0, [0x00], 0, true, false],
        [1, [0x01], 0, true, false],
        [0, [0x00], 1, true, false],
        [1, [0x01], 1, true, false],
        [0, [0x00, 0x00], 2, true, false],
        [1, [0x00, 0x01], 2, true, false],
        [65535, [0xFF, 0xFF], 0, true, false],
        [65280, [0xFF, 0x00], 0, true, false],
        [65280, [0x00, 0xFF], 0, false, false],
        [255, [0xFF, 0x00], 2, false, false],
        [255, [0x00, 0xFF], 2, true, false],
        [255, [0xFF], 1, true, false],
        [255, [0xFF], 1, false, false],
        [256, [0x01, 0x00], 0, true, false]
    ];
}

@test:Config {dataProvider: getEndianConverterTestValues}
function testEndianConverter(int n, byte[] bytes, int minArraySize, boolean endianness, boolean signed) {
    assertEqualsOrError(toBytes(n, minArraySize, endianness, signed), bytes);
}
