#!/bin/sh

echo 'TEST: Common Modes'
echo '#=========================#'
./mons
echo '#=========================#'
echo "test: primary"; sleep 6

./mons -o           ; echo "next: second"           ; sleep 6
./mons -s           ; echo "next: extend left"      ; sleep 6
./mons -e left      ; echo "next: duplicate"        ; sleep 6
./mons -d           ; echo "next: mirror"           ; sleep 6
./mons -m           ; echo "next: extend right"     ; sleep 6
./mons -e right     ; echo "next: extend top"       ; sleep 6
./mons -e top       ; echo "next: extend bottom"    ; sleep 6
./mons -e bottom    ; echo "next: primary"          ; sleep 6
./mons -o           ; echo "next: second"           ; sleep 6
./mons -s           ; echo "next: primary"          ; sleep 6
./mons -o
