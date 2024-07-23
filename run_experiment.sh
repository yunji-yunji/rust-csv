rm ./avg_speed.txt

echo nightly_withoutmiri >> ./avg_speed.txt
cargo +nightly clean
./experiment.sh -nightly_withoutmiri

echo nightly_withmiri >> ./avg_speed.txt
cargo +nightly clean
./experiment.sh -nightly_withmiri

echo fuzz_withoutmiri >> ./avg_speed.txt
cargo +fuzz clean
./experiment.sh -fuzz_withoutmiri

echo fuzz_withmiri >> ./avg_speed.txt
cargo +fuzz clean
./experiment.sh -fuzz_withmiri
