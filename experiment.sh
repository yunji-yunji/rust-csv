#!/bin/sh
echo $TRACE_PATH

run_command() {
    local cmd="$1"
    local total_time=0
    local file_count=0

    for input_file in /tmp/inputs/*; do
        if [ -f "$input_file" ]; then
            start_time=$(date +%s%N)
            eval "$cmd" < "$input_file"
            end_time=$(date +%s%N)
            elapsed=$((end_time - start_time))
            total_time=$((total_time + elapsed))
            file_count=$((file_count + 1))
            # ((file_count++))
        fi
    done
    echo "Total files processed: $file_count"  >> ./avg_speed.txt
    # if (( file_count > 0 )); then
        avg_time=$((total_time / file_count))
        echo "Avg time for ['$cmd']: $((avg_time / 1000000)) ms" >> ./avg_speed.txt
    # else
        # echo "No input files found in /tmp/inputs"
    # fi
}

# run_experiment() {
#     local experiment_arg="$1"
#     case "$experiment_arg" in
while test $# -gt 0; do
    case "$1" in
        -fuzz_withoutmiri)
            cmd="RUSTFLAGS=\"-A warnings\" cargo +fuzz_master run --example fuzz-test-01"
            run_command "$cmd"
            ;;
        -fuzz_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" cargo +fuzz_new miri run --example fuzz-test-01 -- trace=./fuzzwithmiri"
            run_command "$cmd"
            ;;
        -nightly_withoutmiri)
            cmd="RUSTFLAGS=\"-A warnings\" cargo +nightly run --example fuzz-test-01"
            run_command "$cmd"
            ;;
        -nightly_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" cargo +nightly miri run --example fuzz-test-01"
            run_command "$cmd"
            ;;
        -fuzz_jy_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" cargo +fuzz_jy miri run --example fuzz-test-01 -- trace=./fuzzjywithmiri"
            run_command "$cmd"
            ;;
        -fuzz_master_withmiri)
            cmd="RUSTFLAGS=\"-A warnings\" MIRIFLAGS=\"-Zmiri-disable-isolation\" cargo +fuzz_master miri run --example fuzz-test-01 -- trace=./fuzzjywithmiri"
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
