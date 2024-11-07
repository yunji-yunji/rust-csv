#!/bin/sh

CURDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TARGET=${CURDIR}/fuzz
PREFIX=examples

echo $CURDIR
echo $TARGET

while test $# -gt 0; do
    case "$1" in
        -staticdump)
            cargo +fuzz clean
            # rm -rf ${TARGET}
            
            RUSTFLAGS="-A warnings" \
            MIRIFLAGS="-Zmiri-disable-isolation" \
            cargo +fuzz miri run \
                --example fuzz-test-01 -- "static_dump=${TARGET}" "static_prefix=${PREFIX}" \
            ;;
        -runtimedump)
            RUSTFLAGS="-A warnings" \
            MIRIFLAGS="-Zmiri-disable-isolation" \
            cargo +fuzz miri run \
                --example fuzz-test-01 -- "trace=${TRACE_PATH}" \
            ;;
        -base)
            start_time=$(date +%s%N)
            # MIRIFLAGS=-Zmiri-disable-isolation cargo +fuzz_new miri run --example fuzz-test-01 -- trace=trace.json < /dev/null
            MIRIFLAGS=-Zmiri-disable-isolation cargo +fuzz_new miri run --example fuzz-test-01 -- trace=trace.json < /tmp/inputs/smallpop.csv
            end_time=$(date +%s%N)
            elapsed=$((end_time - start_time))
            echo "Elapsed time: $((elapsed / 1000000)) ms"
            ;;
        -junyi)
            start_time=$(date +%s%N)
            MIRIFLAGS=-Zmiri-disable-isolation cargo +fuzz_new4 miri run --example fuzz-test-01 -- trace=trace.json < /tmp/inputs/smallpop.csv
            end_time=$(date +%s%N)
            elapsed=$((end_time - start_time))
            echo "Elapsed time: $((elapsed / 1000000)) ms"
            ;;
        *)
            echo "invalid argument $1"
            exit 1
            ;;
    esac
    shift
done
