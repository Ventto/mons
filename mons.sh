#!/bin/sh
#
# The MIT License (MIT)
#
# Copyright (c) 2018-2019 Thomas "Ventto" Venriès <thomas.venries@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
usage() {
    echo 'Usage: mons [OPTION]...

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

Daemon mode:
  -a    Performs an automatic display if it detects only one monitor.
  -x <script>
        Must be used in conjunction with the -a option. Every time the number
        of connected monitors changes, mons calls the given script with the
        MONS_NUMBER environment variable.

Extra (in-conjunction or alone):
  --dpi <dpi>
        Set the DPI, a strictly positive value within the range [0 ; 27432].
  --primary <mon_name>
        Select a connected monitor as the primary output. Run the script
        without argument to print monitors information, the names are in the
        second column between ids and status. The primary monitor is marked
        by an asterisk.
'
}

version() {
    echo 'Mons 0.8.2
Copyright (C) 2017 Thomas "Ventto" Venries.

License MIT: <https://opensource.org/licenses/MIT>.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
'
}

# Helps to generate manpage with help2man before installing the library
[ "$1" = '-h' ] && { usage; exit; }
[ "$1" = '-v' ] && { version; exit; }
lib='%LIBDIR%/liblist.sh'
[ ! -r "$lib" ] && { "$lib: library not found."; exit 1; }
. "$lib"

arg_err() {
    usage ; exit 2
}

enable_mon() {
    "$XRANDR" --output "$1" --auto
}

disable_mons() {
    for mon in $@; do "$XRANDR" --output "$mon" --off ; done
}

arg2xrandr() {
    case $1 in
        left)   echo '--left-of'    ;;
        right)  echo '--right-of'   ;;
        bottom) echo '--below'      ;;
        top)    echo '--above'      ;;
    esac
}

whichmode() {
    if [ "$(list_size "${disp_mons}")" -eq 1 ]; then
        if echo "${enabled_out}" | grep prima > /dev/null 2>&1; then
            echo 'primary'
        else
            echo 'second'
        fi
    else
        if [ "$(list_size "${plug_mons}")" -gt 2 ] ; then
            echo 'selection'; return 0
        fi

        enabled_out="$(echo "${enabled_out}" | \
                        sed 's/^.*\( [0-9]\+\x[0-9]\++[0-9]\++[0-9]\+\).*/\1/')"

        echo "${enabled_out}" | head -n1 | sed -e 's/+/ /g' | \
        while read -r trash x1 y1; do
            echo "${enabled_out}" | tail -n1 | sed -e 's/x/ /' -e 's/+/ /g' | \
            while read -r w2 h2 x2 y2; do
                echo "${xrandr_out}" | \
                    awk "/^$(list_get 1 "${plug_mons}")/{nr[NR+1]}; NR in nr" | \
                    awk '{print $1;}' | sed -e 's/x/ /' | \
                while read -r wi2 hi2; do
                    if [ "$x1" = "$x2" ] && [ "$y1" = "$y2" ]; then
                        if [ "$w2" != "$wi2" ] || [ "$h2" != "$hi2" ]; then
                            echo 'mirror'
                        else
                            echo 'duplicate'
                        fi
                    else
                        echo 'extend'
                    fi
                done
            done
        done
    fi
}

main() {
    # =============================
    #        Requirements
    # =============================

    [ -z "$DISPLAY" ]  && { echo 'DISPLAY: no variable set.';  exit 1; }
    command -vp xrandr >/dev/null 2>&1 || { echo 'xrandr: command not found.'; exit 1; }
    XRANDR="$(command -pv xrandr)"

    # =============================
    #      Argument Checking
    # =============================

    aFlag=false
    dFlag=false
    eFlag=false
    mFlag=false
    nFlag=false
    oFlag=false
    sFlag=false
    OFlag=false
    SFlag=false
    pFlag=false
    iFlag=false
    xFlag=false
    is_flag=false
    # X has assumed 96 DPI and this is fine for many traditional monitors.
    primary=

    # getopts does not support long options. We convert them to short one.
    for arg in "$@"; do
        shift
        case "$arg" in
            --dpi)      set -- "$@" '-i' ;;
            --primary)  set -- "$@" '-p' ;;
            *)          set -- "$@" "$arg"
        esac
    done

    while getopts 'hvamosde:n:O:S:i:p:x:' opt; do
        case $opt in
            # Long options
            i)
                if ! echo "$OPTARG" | \
                    grep -E '^[1-9][0-9]*$' > /dev/null 2>&1; then
                    arg_err
                fi
                iFlag=true; iArg="$OPTARG"
                ;;
            p)  if ! echo "$OPTARG" | \
                    grep -E '^[a-zA-Z][a-zA-Z0-9\-]+' > /dev/null 2>&1; then
                    arg_err
                fi
                pFlag=true; primary="$OPTARG"
                ;;
            # Short options
            a)  $is_flag && arg_err
                aFlag=true ; is_flag=true
                ;;
            m)  $is_flag && arg_err
                mFlag=true ; is_flag=true
                ;;
            o)  $is_flag && arg_err
                oFlag=true ; is_flag=true
                ;;
            s)  $is_flag && arg_err
                sFlag=true ; is_flag=true
                ;;
            d)  $is_flag && arg_err
                dFlag=true ; is_flag=true
                ;;
            e|n)  $is_flag && arg_err
                case ${OPTARG} in
                    left | right | bottom | top) ;;
                    *) arg_err ;;
                esac
                eArg=$OPTARG
                [ "$opt" = "e" ] && eFlag=true || nFlag=true ; is_flag=true
                ;;
            O)  $is_flag && arg_err
                ! echo "$OPTARG" | grep -E '^[0-9]+$' > /dev/null && arg_err
                OArg=$OPTARG
                OFlag=true ; is_flag=true
                ;;
            S)  $is_flag && arg_err
                idx1="$(echo "$OPTARG" | cut -d',' -f1)"
                idx2="$(echo "$OPTARG" | cut -d',' -f2)"
                area="$(echo "$idx2" | cut -d ':' -f2)"
                idx2="$(echo "$idx2" | cut -d ':' -f1)"
                ! echo "$idx1" | grep -E '^[0-9]+$' > /dev/null && arg_err
                ! echo "$idx2" | grep -E '^[0-9]+$' > /dev/null && arg_err
                ! echo "$area" | grep -E '^[RT]$' > /dev/null && arg_err
                [ "$idx1" = "$idx2" ] && arg_err
                SFlag=true ; is_flag=true
                ;;
            x)  xFlag=true;
                if [ ! -x "$OPTARG" ]; then
                    echo "${OPTARG}: file cannot be executed or does not exist"
                    exit 2
                fi
                xArg="$OPTARG"
                ;;
            h)  usage   ; exit ;;
            v)  version ; exit ;;
            \?) arg_err ;;
            :)  arg_err ;;
        esac
    done

    if $xFlag; then
        if ! $aFlag; then
            echo '-x: option can only be used in conjunction with -a'
            exit 2
        fi
    fi

    # =============================
    #         Daemon Mode
    # =============================

    if $aFlag ; then
        prev=0; i=0
        while true; do
            for status in /sys/class/drm/*/status; do
                [ "$(<"$status")" = 'connected' ] && i=$((i+1))
            done

            if [ "$i" != "$prev" ]; then
                if $xFlag; then
                    MONS_NUMBER="$i" sh "$xArg"
                else
                    [ "$i" -eq 1 ] && "$XRANDR" --auto
                fi
            fi
            prev="$i"; i=0
            sleep 2
        done
    fi

    # List all outputs (except primary one)
    xrandr_out="$("$XRANDR")"
    enabled_out="$(echo "$xrandr_out" | grep 'connect')"
    [ -z "$enabled_out" ] && { echo 'No monitor output detected.'; exit; }
    mons="$(echo "$enabled_out" | cut -d' ' -f1)"

    # List plugged-in and turned-on outputs
    enabled_out="$(echo "$enabled_out" | grep ' connect')"
    [ -z "$enabled_out" ] && { echo 'No plugged-in monitor detected.'; exit 1; }
    plug_mons="$(echo "$enabled_out" | cut -d' ' -f1)"

    if [ "$(list_size "$plug_mons")" -eq 0 ]; then
        echo "No monitor plugged-in."
        exit 0
    fi

    # =============================
    #     Conjunction Options
    # =============================

    # Set DPI
    $iFlag && "$XRANDR" --dpi "$iArg"

    # Set primary output
    if $pFlag; then
        if ! list_contains "$primary" "$plug_mons"; then
            echo "${primary}: output not connected."
            exit 1
        fi
        "$XRANDR" --output "$primary" --primary
        [ "$#" -eq 2 ] && exit
    else
        primary="$(echo "$enabled_out" | grep 'primary' | cut -d' ' -f1)"
    fi

    # Move the primary monitor to the head if connected otherwise the first
    # connected monitor that appears in the xrandr output is considerate as
    # the primary one.
    if [ -n "$primary" ]; then
        plug_mons="$(list_erase "$primary" "$plug_mons")"
        plug_mons="$(list_insert "$primary" 0 "$plug_mons")"
    fi

    enabled_out="$(echo "$enabled_out" | grep -E '\+[0-9]{1,4}\+[0-9]{1,4}')"
    disp_mons="$(echo "$enabled_out" | cut -d' ' -f1)"

    if [ "$#" -eq 0 ]; then
        echo "Monitors: $(list_size "$plug_mons")"
        echo "Mode: $(whichmode)"

        i=0
        for mon in $mons; do
            if echo "$plug_mons" | grep "^${mon}$" > /dev/null; then
                if echo "$disp_mons" | grep "^${mon}$" > /dev/null; then
                    state='(enabled)'
                fi
                if [ "$mon" = "$primary" ]; then
                    printf '%-4s %-8s %-8s %-8s\n' "${i}:*" "$mon" "$state"
                else
                    printf '%-4s %-8s %-8s\n' "${i}:" "$mon" "$state"
                fi
            fi
            i=$((i+1))
            state=
        done
        exit
    fi

    if $nFlag ; then
        case "$(whichmode)" in
            primary)   sFlag=true;;
            second)    eFlag=true;;
            extend)    mFlag=true;;
            mirror)    dFlag=true;;
            duplicate) oFlag=true;;
        esac
    fi

    if [ "$(list_size "$plug_mons")" -eq 1 ] ; then
        if $oFlag ; then
            # After unplugging each monitor, the last preferred one might be
            # still turned off or the window manager might need the monitor
            # reset to cause the reconfiguration of the layout placement.
            "$XRANDR" --auto
        else
            echo 'Only one monitor detected.'
        fi
        exit
    fi

    if $oFlag ; then
        if [ "$(list_size "${disp_mons}")" -eq 1 ]; then
            if [ "$(list_front "${disp_mons}")" = "$(list_front "${plug_mons}")" ]; then
                exit
            fi
        fi
        disp_mons="$(list_erase "$(list_front "${plug_mons}")" "$disp_mons")"
        disable_mons "${disp_mons}"
        enable_mon "$(list_front "${plug_mons}")"
        exit
    fi

    if $OFlag ; then
        if [ "$OArg" -ge "$(list_size "$mons")" ] ; then
            echo "Monitor ID '${OArg}' does not exist."
            echo 'Try without option to get monitor ID list.'
            exit 2
        fi
        mons_elt="$(list_get "$OArg" "$mons")"
        if ! list_contains "${mons_elt}" "${plug_mons}"; then
            echo "Monitor ID '${OArg}' not plugged in."
            echo 'Try without option to get monitor ID list.'
            exit 2
        fi

        disp_mons="$(list_erase "${mons_elt}" "${disp_mons}")"
        disable_mons "${disp_mons}"
        enable_mon "${mons_elt}"
        exit
    fi

    if $SFlag ; then
        if [ "$idx1" -ge "$(list_size "$mons")" ] || \
            [ "$idx2" -ge "$(list_size "$mons")" ]; then
            echo 'One or both monitor IDs do not exist.'
            echo 'Try without option to get monitor ID list.'
            exit 2
        fi
        if ! list_contains "$(list_get "$idx1" "$mons")" "$plug_mons" || \
            ! list_contains "$(list_get "$idx2" "$mons")" "$plug_mons" ; then
            echo 'One or both monitor IDs are not plugged in.'
            echo 'Try without option to get monitor ID list.'
            exit 2
        fi

        [ "$area" = 'R' ] && area="--right-of" || area="--above"

        mon1="$(list_get "$idx1" "$mons")"
        mon2="$(list_get "$idx2" "$mons")"
        disp_mons="$(list_erase "$mon1" "$disp_mons")"
        disp_mons="$(list_erase "$mon2" "$disp_mons")"
        disable_mons "$disp_mons"
        enable_mon "$mon1"
        enable_mon "$mon2"
        "$XRANDR" --output "$mon2" "$area" "$mon1"
        exit
    fi

    # =============================
    #     2-Monitors Options
    # =============================

    if [ "$(list_size "$plug_mons")" -eq 2 ]; then
        if $sFlag ; then
            if [ "$(list_size "$disp_mons")" -eq 1 ] ; then
                if [ "$(list_front "$disp_mons")" = "$(list_get 1 "$plug_mons")" ] ; then
                    enable_mon "$(list_get 1 "$plug_mons")"
                    exit
                fi
            fi
            enable_mon "$(list_get 1 "$plug_mons")"
            disable_mons "$(list_front "$disp_mons")"
            exit
        fi

        # Resets the screen configuration
        disable_mons "$(list_get 1 "$plug_mons")"
        "$XRANDR" --auto

        if $dFlag ; then
            "$XRANDR" --output "$(list_get 1 "$plug_mons")" \
                --same-as "$(list_front "$plug_mons")"
            exit $?
        fi

        if $mFlag ; then
            xrandr_out="$(echo "$xrandr_out" | \
                          awk "/primary/{nr[NR]; nr[NR+1]}; NR in nr")"
            if echo "$xrandr_out" | \
                grep -E 'primary [0-9]+x[0-9]+' >/dev/null 2>&1; then
                size="$(echo "$xrandr_out" | head -n1 | cut -d' ' -f4 | \
                        cut -d'+' -f1)"
            else
                size="$(echo "$xrandr_out" | tail -n1 | awk '{ print $1 }')"
            fi

            "$XRANDR" --output "$(list_get 1 "$plug_mons")" \
                --auto --scale-from  "$size" \
                --output "$(list_front "$plug_mons")"
            exit $?
        fi

        if $eFlag ; then
            "$XRANDR" --output "$(list_get 1 "$plug_mons")" \
                "$(arg2xrandr "$eArg")" "$(list_front "$plug_mons")"
            exit $?
        fi
    else
        echo 'At most two plugged monitors for this option.'
    fi
}

main "$@"
