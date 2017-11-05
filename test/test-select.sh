#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo 'Usage: test-select.sh MON_ID1 MON_ID2 MON_ID3'
    echo
    echo 'Three monitor ids are required. Ids are given by `mons`.'
    exit 1
fi

echo 'TEST: Selections'
echo '#=========================#'
./mons
echo '#=========================#'

./mons -O "$1"      ; echo "test: single select $1"         ; sleep 8
./mons -O "$2"      ; echo "test: single select $2"         ; sleep 8
./mons -O "$3"      ; echo "test: single select $3"         ; sleep 8
./mons -O "$1"      ; echo "test: single select $1"         ; sleep 8
./mons -S "$1,$2:R" ; echo "test: single select $1,$2:R"    ; sleep 8
./mons -S "$1,$2:T" ; echo "test: multi select $1,$2:T"     ; sleep 8
./mons -S "$3,$2:T" ; echo "test: multi select $3,$2:T"     ; sleep 8
./mons -S "$2,$3:R" ; echo "test: multi select $2,$3:R"     ; sleep 8
./mons -S "$3,$1:T" ; echo "test: multi select $3,$1:T"     ; sleep 8
./mons -O "$1"      ; echo "test: single select $1"
