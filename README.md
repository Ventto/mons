Mons
===================
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/mons/blob/master/LICENSE)
[![Language (XRandR)](https://img.shields.io/badge/powered_by-XRandR-brightgreen.svg)](https://www.x.org/archive/X11R7.5/doc/man/man1/xrandr.1.html)

*"Mons is a Shell script to quickly manage 2-monitors display using xrandr."*

## Perks

* [x] **No requirement**: POSIX-compliant.
* [x] **Useful**: Perfectly fit for laptops, quick and daily use.
* [x] **Well known**: Laptop mode, projector mode, duplicate, mirror and extend.
* [x] **More**: Select, move monitors and switch modes easily.
* [x] **Extra**: Deamon mode option to reset display if detects only one monitor.

# Installation

* Package (AUR)

```
$ pacaur -S mons
```

* Manual

```
$ git clone --recursive https://github.com/Ventto/mons.git
$ cd mons
$ sudo make install
```
> Note: `--recursive` is needed for git submodule

# Usage

```
Usage: mons [OPTION]...

Options can not be used in conjunction.
If no argument, prints plugged-in monitor ID list.

Information:
  -h:   Prints this help and exits.
  -v:   Prints version and exits.

Two monitors:
  -o:   Preferred monitor only.
  -s:   Second monitor only.
  -d:   Duplicates.
  -e:   Extends [ top | left | right | bottom ].
  -m:   Mirror of the preferred monitor.

More monitors:
  -O:   Enables only the selected monitor.
  -S:   Enables only two monitors [MON1,MON2:P],
        MON1 and MON2 are monitor IDs,
        P takes the value [R] right or [T] top for the MON2's placement.

Daemon mode:
  -a:   Re-establishs the display if it detects only one monitor.
```

# Examples

## Two monitors

Displays monitor list:

```
$ mons
0: LVDS-1   (enabled)
5: VGA-1
```

You have an enabled one, you want to extends the second one on the right:

```
$ mons -e right
```

You want to only display the second one:

```
$ mons -s
```

## Three monitors


Displays monitor list:

```
$ mons
0: LVDS-1   (enabled)
1: DP-1     (enabled)
5: VGA-1
```

You may need to display only the third one:

```
$ mons -O 5
```

You may need to display the first and the third one on the right:

```
$ mons -S 0,5:R
```

Like above but you want to inverse the placement:

```
$ mons -S 5,0:R
```

## Daemon mode

Especially for laptops, after unplugging the additional monitors, it might be
convenient to reset automatically the display for the remaining one.

Run *mons* in background as follow:

```
$ nohup mons -a > /dev/null 2>&1 &  (all shells)
$ mons -a &!                        (zsh)
$ mons -a &; disown                 (bash)
```
