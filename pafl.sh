#!/bin/sh

CURDIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
TARGET=${CURDIR}/fuzz
PREFIX=examples

echo $CURDIR
echo $TARGET

while test $# -gt 0; do
    case "$1" in
        -staticdump)
            # set stdin with path_to_csv_file
            cargo +fuzz clean
            # rm -rf ${TARGET}
            
            RUSTFLAGS="-A warnings" \
            MIRIFLAGS="-Zmiri-disable-isolation" \
            STATIC_DUMP=${TARGET} \
            PAFL_TARGET_PREFIX=${PREFIX} \
            cargo +fuzz miri run \
                --example fuzz-test-01 \
            ;;
        -runtimedump)
            # you need to specify the TRACE_PATH 
            # set stdin with path_to_csv_file
            cargo +fuzz clean

            RUSTFLAGS="-A warnings" \
            MIRIFLAGS="-Zmiri-disable-isolation" \
            RUNTIME_DUMP=${TRACE_PATH} \
                cargo +fuzz miri run \
                    --example fuzz-test-01 \
            ;;
        *)
            echo "invalid argument $1"
            exit 1
            ;;
    esac
    shift
done
