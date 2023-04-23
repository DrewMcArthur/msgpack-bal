import ballerina/time;
import ballerina/io;
import msgpack.core;

# runs benchmarks for the parent dir
# based on the [ballerina-lang benchmarks](https://github.com/ballerina-platform/ballerina-lang/tree/master/benchmarks)
#
# + functions - a map of BenchmarkFunctions to test
public function runBenchmarks(map<BenchmarkFunction> functions) {
    map<Benchmark> results = executeBenchmarks(functions);

    foreach string functionName in results.keys() {
        io:println(printBenchmark(functionName, results.get(functionName)));
    }
}

function printBenchmark(string functionName, Benchmark result) returns string {
    return string `${core:padStr(16, functionName, " ")} | ${core:padNum(12, (<float>result.avgTime) * 1000)} | ${core:padNum(12, <float>result.totalTime)}`;
}

type Benchmark record {
    int nRuns;
    time:Seconds totalTime;
    time:Seconds avgTime;
};

public type BenchmarkFunction function () returns error?;

function executeBenchmarks(map<BenchmarkFunction> functions) returns map<Benchmark> {
    map<Benchmark> results = {};
    foreach string functionName in functions.keys() {
        results[functionName] = executeBenchmark(functions.get(functionName));
    }
    return results;
}

function executeBenchmark(BenchmarkFunction fn) returns Benchmark {
    int warmupRuns = 25;
    int benchmarkRuns = 50000;

    int i = 0;
    while i < warmupRuns {
        checkpanic fn();
        i = i + 1;
    }

    i = 0;
    var startTime = time:utcNow();
    while i < benchmarkRuns {
        checkpanic fn();
        i = i + 1;
    }
    var endTime = time:utcNow();

    var totalTime = time:utcDiffSeconds(endTime, startTime);

    return {
        nRuns: benchmarkRuns,
        totalTime: totalTime,
        avgTime: totalTime / benchmarkRuns
    };
}
