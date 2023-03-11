#!/bin/bash
data=( `cat /root/hour.conf | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d %H:%M:%S"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/root/hour.conf" | cut -d ' ' -f 3-5)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
# exp2=$(( (d1 - d2) / 86400 ))
if [[ "$d2" -ge "$d1" ]]; then
sed -i "/^### $user $exp/d" "/root/hour.conf"
if getent passwd $user > /dev/null 2>&1; then
        userdel $user
fi
fi
done
