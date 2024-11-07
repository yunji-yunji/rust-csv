rm ./avg_speed.txt

# echo nightly_withoutmiri >> ./avg_speed.txt
# cargo +nightly clean
# ./experiment.sh -nightly_withoutmiri
# 
echo nightly_withmiri >> ./avg_speed.txt
cargo +nightly clean
./experiment.sh -nightly_withmiri

# # echo fuzz_withoutmiri >> ./avg_speed.txt
# # cargo +fuzz_master clean
# # ./experiment.sh -fuzz_withoutmiri

echo fuzz_master_withmiri >> ./avg_speed.txt
cargo +fuzz_master clean
./experiment.sh -fuzz_master_withmiri


echo fuzz_withmiri >> ./avg_speed.txt
cargo +fuzz_new clean
./experiment.sh -fuzz_withmiri

echo fuzz_jy_withmiri >> ./avg_speed.txt
cargo +fuzz_jy clean
./experiment.sh -fuzz_jy_withmiri

