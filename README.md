Docilemons
===================

## Description
Docilemons is a Shell script using XRandR to manage at the most two monitors
plug to a laptop.

Dependence:
* libxrandr - X11 RandR extension library

## Usage
``docilemons [OPTION]...``

Options can not be used in conjunction.

### Information:
* (none): Print information about monitors
* -h: Print this help and exit

### 1-PluggedIn monitor options (laptop + 1 monitor):
* -o:	Computer only
* -s:	Second monitor only
* -d:	Duplicate
* -e [left | right | bottom | up] : Extend

### 2-PluggedIn monitors options (laptop + 2 monitors):
* -C [ ID ],[ ID ][POSITION] : Selection of two monitors plugged in
	- [ ID ]: Monitor's ID (run docilemons without option to get monitor IDs).<br>
	[ POSITION ]: 'R' or 'U',
	'R' the second selected monitor will be on the right and 'U' upwards,
	(cf. Examples).
* -F:	First monitor (if on the left or below it will be the only one enabled)
* -S:	Second monitor (same logic with 'right or above')

## Examples
### Laptop + 1 monitor
```
$ docilemons
// output
0:LVDS-1 [ENABLED]    <-- laptop monitor at first
5:VGA-1

$ docilemons -e right <--  VGA-1 will be on the right
$ docilemons
// output
0:LVDS-1 [ENABLED]
5:VGA-1  [ENABLED]

$ docilemons -s       <-- VGA-1 will be the only one enabled
$ docilemons
// output
0:LVDS-1              <-- LVDS-1 disabled
5:VGA-1  [ENABLED]

$ docilemons -o
$ docilemons
// output
0:LVDS-1 [ENABLED]
5:VGA-1

```

### Laptop + 2 monitors
```
$ docilemons
// output
0:LVDS-1 [ENABLED]    <-- laptop monitor at first
2:DP-2
5:VGA-1

$ docilemons -C 2,5R  <-- DP-2 left, VGA-1 right
$ docilemons
// output
0:LVDS-1              <-- plugged in but disabled
2:DP-2   [ENABLED]    <-- plugged in and enabled
5:VGA-1  [ENABLED]

$ docilemons -S       <-- VGA-1 will be the only one enabled
$ docilemons
// output
0:LVDS-1
2:DP-2
5:VGA-1  [ENABLED]

$ docilemons -o       <-- Laptop's monitor will be the only one enabled
$ docilemons
0:LVDS-1 [ENABLED]
2:DP-2
5:VGA-1

```

## TODO
* Testing the script on different computers to figure out unexpecting result.
* ~~Manage 2-selected monitors with invariant IDs (sometimes xrandr is surprising)~~
