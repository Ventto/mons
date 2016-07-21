Docilemons
===================

## Description
Docilemons is a stupid Shell script as a tiny abstraction of xrandr to manage
two monitors's display configuration. It may be useful for a usage of laptop
with a monitor.

## Usage
``docilemons [OPTION]...``

### Operations (can not be used in conjunction):
* -h:	Print this help and exit
* -o:	Computer only
* -s:	Second monitor only
* -d:	Duplicate

### Modes (used with a position argument):
Positions (left | right | bottom | up)
* -e:	Extend

## Examples
```
$ docilemons -o
$ docilemons -d
$ docilemons -e left
```
