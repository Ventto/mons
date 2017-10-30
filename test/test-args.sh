#!/bin/sh

# Caution: Required three monitors

[ "$#" -ne 3 ] && { echo 'Three monitor ids are required.'; exit 2; }

echo 'TEST: Bad Arguments'
echo '#=========================#'
./mons
echo '#=========================#'
echo 'test: common'

n=1
./mons --s -o       >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --o          >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -e fekl56    >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -e 2         >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -e pot       >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -d 2         >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))
./mons -m 2         >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))

echo 'test: single selection'

n=1
./mons -O 5 "$1"    >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -O abc "$2"  >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --O "$3"     >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -O           >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))

echo 'test: multi selection'

n=1
./mons -S           >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -S "$1,$2:P" >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -S "$3,$2:5" >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -S "$2:R"    >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -S "$3,$1"   >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -S "A,B:R"   >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))

echo 'test: dpi'

n=1
./mons --dpi                >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi A              >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi 0              >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi -0             >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi -5             >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi -3000          >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --dpi -s 1           >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
# Weird configuration
./mons -e --dpi 96 left     >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))
./mons -n --dpi 72 right    >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))

echo 'test: primary'
n=1
./mons --primary                >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary -HDMI1         >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary -HDMI1         >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary 1HDMI          >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary -s 1           >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -n --primary HDMI1       >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -n --primary HDMI1 left  >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))
./mons -n --primary HDMI1 left -s   >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))

echo 'test: dpi + primary'
n=1
./mons --primary --dpi          >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary --dpi 75       >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary HDMI1 --dpi    >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary HDMI1 --dpi 0  >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary 1HDMI --dpi 0  >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary HDMI1 --dpi HDMI1  >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons --primary HDMI1 --dpi 75 >/dev/null 2>&1 && echo "failed: $n" ; n=$((n+1))
./mons -n --primary HDMI1 --dpi 75 left >/dev/null 2>&1 || echo "failed: $n" ; n=$((n+1))
