Docilemons
===================

## Description
Docilemons is a Shell script using XRandR to manage the displaying of
two monitors (at the most). It was written mainly for a usage of a laptop
with one or two monitors plugged in.

Dependence:
* libxrandr - X11 RandR extension library

## Usage
``docilemons [OPTION]...``

Each option can not be used in conjunction.

### Information:
* (none):	Print information about monitors.
* -h:		Print this help and exit

### 1-PluggedIN monitor options (laptop + 1 monitor):
* -o:	Computer only
* -s:	Second monitor only
* -d:	Duplicate
* -e [left | right | bottom | up] : Extend

### 2-PluggedIN monitors options (laptop + X monitors):
The following options manage at the most two chosen monitors.

* -C [ ID ],[ ID ][POSITION] : Selection of two monitors plugged in
	- [ ID ]: Run docilemons without option to get monitor IDs.<br>
	[ POSITION ]: 'R' or 'U',
	'R' the second monitor will be displayed on the right and 'U' up in the sky.<br>
* -F:	First monitor (left or below)
* -S:	Second monitor (right or above)

## Examples
```
$ docilemons
// output
0:LVDS-1 [ENABLED] <-- laptop monitor
2:DP-2
5:VGA-1

$ docilemons -C 2,5R
$ docilemons
// output
0:LVDS-1
2:DP-2   [ENABLED]
5:VGA-1  [ENABLED]

$ docilemons -S
$ docilemons
// output
0:LVDS-1
2:DP-2
5:VGA-1  [ENABLED]

$ docilemons -o
$ docilemons
0:LVDS-1 [ENABLED]
2:DP-2
5:VGA-1

```

## TODO
* Testing the script on different computers to figure out unexpecting result.
* ~~Manage 2-selected monitors with invariant IDs (sometimes xrandr is surprising)~~
