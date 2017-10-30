#!/bin/sh

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
