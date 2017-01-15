Mons
===================
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/mons/blob/master/LICENSE)
[![Status](https://img.shields.io/badge/status-experimental-orange.svg?style=flat)](https://github.com/Ventto/mons)
[![Language (Bash)](https://img.shields.io/badge/powered_by-Bash-brightgreen.svg)](https://www.gnu.org/software/bash)

*"Mons is a Bash script to easily manage monitors placement using xrandr."*

The purpose is to use *mons* as shortcut and quick command on a daily basis or at boot.

# Installation

*"Installation as AUR package, soon."*

```
$ git clone https://github.com/Ventto/mons.git
$ cd mons
$ chmod +x src/mons.sh
$ ./src/mons.sh
```

# Usage

```
Usage: mons [OPTION]...
Options can not be used in conjunction.

Information:
  none: Prints monitor ID list
  -h:   Prints this help and exits
  -v:   Prints version and exits

Two monitors:
  -o:   Preferred monitor only
  -s:   Second monitor only
  -d:   Duplicates
  -e:   Extends [ top | left | right | bottom ]

More monitors:
  -O:   Enables only the selected monitor
  -S:   Enables only two monitors [MON1,MON2:P]
       MON1 and MON2 are monitor IDs given by the information option,
       P is the placement position, [R] right or [B] bottom for MON2.
```

# Examples

## Two monitors

Displays monitor list:

```
$ mons
0: LVDS-1   (enabled)
1: DP-1
2: DP-2
3: eDP-1
4: DP-3
5: VGA-1    (plugged)
```

You have an enabled one, you want to extends the second one on the right:

```
$ mons -e right
```

You want to display the second one only:

```
$ docilemons -s
```

## Three monitors


Displays monitor list:

```
$ mons
0: LVDS-1   (enabled)
1: DP-1     (enabled)
2: DP-2
3: eDP-1
4: DP-3
5: VGA-1    (plugged)
```

You may need to display only the third one:

```
$ mons -O 5
```

You may need to display the first and the third one on the right:

```
$ mons -S 0,5R
```

Like above but you want to inverse the placement:

```
$ mons -S 5,0R
```





