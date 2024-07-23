#!/bin/sh

echo $TRACE_PATH

run_command() {
    local cmd="$1"
    local total_time=0

    for i in $(seq 1 100); do
        start_time=$(date +%s%N)
        eval "$cmd"
        end_time=$(date +%s%N)
        elapsed=$((end_time - start_time))
        total_time=$((total_time + elapsed))
    done

    avg_time=$((total_time / 100))
    echo "Avg time for ['$cmd']: $((avg_time / 1000000)) ms" >> ./avg_speed.txt
}

# run_experiment() {
#     local experiment_arg="$1"
#     case "$experiment_arg" in
while test $# -gt 0; do
    case "$1" in
        -fuzz_withoutmiri)
            cmd="RUSTFLAGS=\"-A warnings\" cargo +fuzz run --example fuzz-test-01 < examples/data/smallpop.csv"
            run_command "$cmd"
            ;;
        -fuzz_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" RUNTIME_DUMP=\"./fuzz_withmiri\" cargo +fuzz miri run --example fuzz-test-01 < examples/data/smallpop.csv"
            run_command "$cmd"
            ;;
        -nightly_withoutmiri)
            cmd="RUSTFLAGS=\"-A warnings\" cargo +nightly run --example fuzz-test-01 < examples/data/smallpop.csv"
            run_command "$cmd"
            ;;
        -nightly_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" cargo +nightly miri run --example fuzz-test-01 < examples/data/smallpop.csv"
            run_command "$cmd"
            ;;
        *)
            echo "invalid argument $1"
            exit 1
            ;;
    esac
    shift
done
# }
