#!/bin/sh

echo 'TEST: Selections'
echo '#=========================#'
./mons
echo '#=========================#'
echo "next: select $1"; sleep 6

./mons -O "$1"      ; echo "next: single select $2"         ; sleep 6
./mons -O "$2"      ; echo "next: single select $3"         ; sleep 6
./mons -O "$3"      ; echo "next: single select $1"         ; sleep 6
./mons -O "$1"      ; echo "next: single select $1,$2:R"    ; sleep 6
./mons -S "$1,$2:R" ; echo "next: multi select $1,$2:T"     ; sleep 6
./mons -S "$1,$2:T" ; echo "next: multi select $3,$2:T"     ; sleep 6
./mons -S "$3,$2:T" ; echo "next: multi select $2,$3:R"     ; sleep 6
./mons -S "$2,$3:R" ; echo "next: multi select $3,$1:T"     ; sleep 6
./mons -S "$3,$1:T" ; echo "next: single select $1"         ; sleep 6
./mons -O "$1"
