Mons
===================
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Ventto/mons/blob/master/LICENSE)
[![Language (XRandR)](https://img.shields.io/badge/powered_by-XRandR-brightgreen.svg)](https://www.x.org/archive/X11R7.5/doc/man/man1/xrandr.1.html)
[![Vote for mons](https://img.shields.io/badge/AUR-Vote_for-yellow.svg)](https://aur.archlinux.org/packages/mons/)
[![Donate](https://img.shields.io/badge/Donate-paypal-orange.svg)](https://paypal.me/tvenries)


*"Mons is a Shell script to quickly manage 2-monitors display using xrandr."*

## Perks

* [x] **No requirement**: POSIX-compliant (minimal: *xorg-xrandr*)
* [x] **Useful**: Perfectly fit for laptops, quick and daily use
* [x] **Well known**: Laptop mode, projector mode, duplicate, mirror and extend
* [x] **More**:  Select one or two monitors over several others
* [x] **Extra**: Cycle through every mode with only one shortcut
* [x] **Auto**: Daemon mode to automatically reset display

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
Without argument, it prints connected monitors list with their names and ids.
Options are exclusive and can be used in conjunction with extra options.

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
        Only enables the monitor with a specified id.
  -S <mon1>,<mon2>:<pos>
        Only enables two monitors with specified ids. The specified position
        places the second monitor on the right (R) or at the top (T).

Extra (in-conjunction options):
  --dpi <dpi>
        Set the DPI, a strictly positive value within the range [0 ; 27432].
  --primary <mon_name>
        Select a connected monitor as the primary output. Run the script
        without argument to print monitors information, the names are in the
        second column between ids and status. The primary monitor is marked
        by an asterisk.

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

With the `-n` option, go through every 2-mons mode consecutively:

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
0:* LVDS-1   (enabled)
1: DP-1      (enabled)
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

## DPI value

You might want to switch mode and set the DPI value.
Use the `--dpi <dpi>` option in conjunction with all others options.

```
$ mons [OPTIONS] --dpi <dpi>
```

## Primary monitor

You might choose one of your monitors as the main one.
You can use the `--primary <mon_name>` option alone or in conjunction with all
others options.
`<mon_name>` refers to the monitor name that appears in the list of connected
monitors (ex: `LVDS-1` or `VGA-1`):

```
$ mons
Monitors: 3
Mode: Primary
0:* LVDS-1   (enabled)
5:  VGA-1
```

The '*' character means that the monitor is the primary one:

```
$ mons --primary VGA-1
Monitors: 3
Mode: Primary
0:  LVDS-1   (enabled)
5:* VGA-1
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
