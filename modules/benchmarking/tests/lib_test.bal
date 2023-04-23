import ballerina/test;
import ballerina/io;
import drew/msgpack;
import msgpack.core;

@test:BeforeSuite
function printBenchmarkHeader() {
    io:println(string `${core:padStr(16, "function name")} | ${core:padStr(12, "avgTime (ms)")} | ${core:padStr(12, "totalTime (s)")}`);
}

@test:Config { dataProvider:  getBenchmarkFunctions }
function runAll(string funcName, BenchmarkFunction func) {
    Benchmark result = executeBenchmark(func);
    io:println(printBenchmark(funcName, result));
}

function getBenchmarkFunctions() returns map<(string|BenchmarkFunction)[]> {
    return {
        "encodeEmptyMap": ["encodeEmptyMap", encodeEmptyMap],
        "encodeMap": ["encodeMap", encodeMap]
    };
}

function encodeEmptyMap() returns error? {
    json obj = {};
    byte[] _ = check msgpack:encode(obj);
}

function encodeMap() returns error? {
    json obj = {
        "a": "b"
    };
    byte[] _ = check msgpack:encode(obj);
}
