Mons
===================
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/mons/blob/master/LICENSE)
[![Language (XRandR)](https://img.shields.io/badge/powered_by-XRandR-brightgreen.svg)](https://www.x.org/archive/X11R7.5/doc/man/man1/xrandr.1.html)
[![Vote for mons](https://img.shields.io/badge/AUR-Vote_for-yellow.svg)](https://aur.archlinux.org/packages/mons/)



*"Mons is a Shell script to quickly manage 2-monitors display using xrandr."*

## Perks

* [x] **No requirement**: POSIX-compliant (minimal: *xorg-xrandr*)
* [x] **Useful**: Perfectly fit for laptops, quick and daily use
* [x] **Well known**: Laptop mode, projector mode, duplicate, mirror and extend
* [x] **More**:  Select one or two monitors over several others
* [x] **Extra**: Cycle through every mode with only one shortcut
* [x] **Auto**: Deamon mode to automatically reset display

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
If no argument, prints plugged-in monitor list with their ids.

Information:
  -h    Prints this help and exits.
  -v    Prints version and exits.

Two monitors:
  -o    Primary monitor only.
  -s    Second monitor only.
  -d    Duplicates the primary monitor.
  -m    Mirrors the primary monitor.
  -e <side>
         Extends the primary monitor to the selected side
         [ top | left | right | bottom ].
  -n <side>
         This mode selects the previous ones, one after another. The argument
         sets the side for the extend mode.

More monitors:
  -O <mon>
        Only enables the selected monitor wuth an id.
  -S <mon1>,<mon2>:<pos>
        Only enables two selected monitors with ids (<mon1>, <mon2>),
        <pos> places the second one to the right or at top [R | T].

Daemon mode:
  -a    Performs an automatic display if it detects only one monitor.
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

Go through every 2-monitors mode according the following sequence:

1. Primary monitor only
1. Second monitor only
1. Extend mode whose the side is set with `-n <side>`
1. Mirror
1. Duplicate

This mode is useful if you want to switch to every mode with only one shortcut.

![alt 2-monitors modes](img/raw-body.png)

```
# Now in 'Second monitor mode'
$ mons -n right # -> 'Extend mode'
# Now in 'Extend mode'
$ mons -n right # -> 'Mirror mode'
```

## Three monitors (selection mode)


Displays monitor list:

```
$ mons
Monitors: 3
Mode: Selection
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
