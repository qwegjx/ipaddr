#!/bin/sh

set -e

cd $(dirname $0)
curr=$(pwd)
dest="$curr/ip.txt"
key="$curr/get_ip.password.tmp"

encode() {
    git pull

    cd $curr
    theip=$(ip addr | grep "inet6* " | sort)

    md5=$(echo -n "$theip" | md5sum)
    md5file=md5.txt
    if [ "$md5" = "$(cat $md5file)" ]; then
	    return
    fi

    echo $md5 > $md5file
    echo -n "$theip" | openssl enc -aes-256-cbc -salt -base64 -k "$(cat $key)" > $dest

    git add $dest
    git commit -m "update ip"
    git push
}

decode() {
    cat $dest | openssl enc -d -aes-256-cbc -base64 -k "$(cat $key)"
}

if [ "$1" = "decode" ]; then
    decode
else
    s=$(uname -a | grep OpenWrt) || true
    if [ -n "$s" ]; then
        encode
    else
        echo "Only OpenWrt system can run this script to update ip address, but you can run 'sh get_ip.sh decode' to get the ip address if you have the password."
    fi
fi
