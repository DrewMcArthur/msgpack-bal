public function getTestCases() returns TestCase[][] {
    return [
        [{"input": null, "output": [0xc0]}],
        [{"input": false, "output": [0xc2]}],
        [{"input": true, "output": [0xc3]}],
        [{"input": 0, "output": [0x00]}],
        [{"input": 1, "output": [0x01]}],
        [{"input": 127, "output": [0x7f]}],
        [{"input": -1, "output": [0xff]}],
        [{"input": -32, "output": [0xe0]}],
        [{"input": 128, "output": [0xcc, 0x80]}],
        [{"input": 255, "output": [0xcc, 0xff]}],
        [{"input": 256, "output": [0xcd, 0x01, 0x00]}],
        [{"input": 65535, "output": [0xcd, 0xff, 0xff]}],
        [{"input": 65536, "output": [0xce, 0x00, 0x01, 0x00, 0x00]}],
        [{"input": 65537, "output": [0xce, 0x00, 0x01, 0x00, 0x01]}],
        [{"input": 11111111111, "output": [0xcf, 0x00, 0x00, 0x00, 0x02, 0x96, 0x46, 0x19, 0xc7]}],
        [{"input": 1111111111111111168, "output": [0xcf, 0x0f, 0x6b, 0x75, 0xab, 0x2b, 0xc4, 0x72, 0x00]}],
        [{"input": -33, "output": [0xd0, 0xdf]}],
        [{"input": -40, "output": [0xd0, 0xd8]}],
        [{"input": -127, "output": [0xd0, 0x81]}],
        [{"input": -128, "output": [0xd1, 0xff, 0x80]}],
        [{"input": -405, "output": [0xd1, 0xfe, 0x6b]}],
        [{"input": -32767, "output": [0xd1, 0x80, 0x01]}],
        [{"input": -32768, "output": [0xd2, 0xff, 0xff, 0x80, 0x00]}],
        [{"input": -32769, "output": [0xd2, 0xff, 0xff, 0x7f, 0xff]}],
        // [{"input": -11111111111, "output": [0xd3, 0xff, 0xff, 0xff, 0xfd, 0x69, 0xb9, 0xe6, 0x39]}],
        [
            {"input": "", "output": [0xa0]}
        ],
        [{"input": "A", "output": [0xa1, 0x41]}],
        [{"input": "ab", "output": [0xa2, 0x61, 0x62]}],
        [
            {
                "input": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                "output": [0xbf, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61,0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61,0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61, 0x61]
            }
        ],
        [
            {
                "input": "short string, under 31 bytes!",
                "output": [
                    0xbd,
                    0x73,
                    0x68,
                    0x6f,
                    0x72,
                    0x74,
                    0x20,
                    0x73,
                    0x74,
                    0x72,
                    0x69,
                    0x6e,
                    0x67,
                    0x2c,
                    0x20,
                    0x75,
                    0x6e,
                    0x64,
                    0x65,
                    0x72,
                    0x20,
                    0x33,
                    0x31,
                    0x20,
                    0x62,
                    0x79,
                    0x74,
                    0x65,
                    0x73,
                    0x21
                ]
            }
        ],
        [{"input": {}, "output": [0x80]}],
        [{"input": [], "output": [0x90]}],
        [{"input": [0], "output": [0x91, 0x00]}],
        [
            {
                "input": {"a": "b"},
                "output": [0x81, 0xa1, 0x61, 0xa1, 0x62]
            }
        ],
        [
            {
                "input": {"id": 0},
                "output": [0x81, 0xa2, 0x69, 0x64, 0x00]
            }
        ]
    ];
}
