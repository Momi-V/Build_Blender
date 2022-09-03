modprobe zram
cat /sys/block/zram0/max_comp_streams
cat /sys/block/zram0/comp_algorithm
echo 4G > /sys/block/zram0/disksize

mkswap /dev/zram0
swapon /dev/zram0
