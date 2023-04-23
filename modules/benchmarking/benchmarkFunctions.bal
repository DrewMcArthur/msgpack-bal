import drew/msgpack;

public type BenchmarkFunction function () returns error?;

function getBenchmarkFunctions() returns map<(string|BenchmarkFunction)[]> {
    return {
        "encodeEmptyMap": ["encodeEmptyMap", encodeEmptyMap],
        "encodeMap": ["encodeMap", encodeMap1],
        "encodeMap15": ["encodeMap15", encodeMap15],
        "encodeFixint": ["encodeFixint", encodeFixint],
        "encodeFixstr": ["encodeFixstr", encodeFixstr],
        "encodeFixArray": ["encodeFixArray", encodeFixArray]
    };
}

function encodeEmptyMap() returns error? {
    json obj = {};
    byte[] _ = check msgpack:encode(obj);
}

function encodeMap1() returns error? {
    json obj = {
        "a": "b"
    };
    byte[] _ = check msgpack:encode(obj);
}

function encodeMap15() returns error? {
    json obj = {
        "a": "a",
        "b": "a",
        "c": "a",
        "d": "a",
        "e": "a",
        "f": "a",
        "g": "a",
        "h": "a",
        "i": "a",
        "j": "a",
        "k": "a",
        "l": "a",
        "m": "a",
        "n": "a",
        "o": "a"
    };
    byte[] _ = check msgpack:encode(obj);
}

function encodeFixint() returns error? {
    byte[] _ = check msgpack:encode(10);
}

function encodeFixstr() returns error? {
    byte[] _ = check msgpack:encode("hi");
}

function encodeFixArray() returns error? {
    int[] a = [0, 1, 2, 3, 4];
    byte[] _ = check msgpack:encode(a);
}
