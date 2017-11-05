#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo 'Usage: test-common.sh CURR_MON_NAME MON_NAME'
    echo
    echo 'Monitor names are required. Names are given by "mons".
CURR_MON_NAME is your current monitor and the second one is reserved
for primary test.'
    exit 1
fi

Test_Common () {
    echo 'TEST: Common Modes'
    echo '#=========================#'
    ./mons
    echo '#=========================#'

    ./mons -o           ; echo "test: primary"          ; sleep 8
    ./mons -s           ; echo "test: second"           ; sleep 8
    ./mons -e left      ; echo "test: extend left"      ; sleep 8
    ./mons -d           ; echo "test: duplicate"        ; sleep 8
    ./mons -m           ; echo "test: mirror"           ; sleep 8
    ./mons -e right     ; echo "test: extend right"     ; sleep 8
    ./mons -e top       ; echo "test: extend top"       ; sleep 8
    ./mons -e bottom    ; echo "test: extend bottom"    ; sleep 8
    ./mons -o           ; echo "test: primary"          ; sleep 8
    ./mons -s           ; echo "test: second"           ; sleep 8
    ./mons -o           ; echo "test: primary"
}

./mons -o --primary "$1"
Test_Common
./mons -o --primary "$2"
echo "[ Primary has been set: $1 ]"
Test_Common
./mons -o --primary "$1"
