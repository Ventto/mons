#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015-2016 Thomas "Ventto" Venriès <thomas.venries@gmail.com>
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
    echo -e "Usage: mons [OPTION]...
Options can not be used in conjunction.

Information:
  none:\tPrints monitor ID list
  -h:\tPrints this help and exits
  -v:\tPrints version and exits

Two monitors:
  -o:\tPreferred monitor only
  -s:\tSecond monitor only
  -d:\tDuplicates
  -e:\tExtends [ top | left | right | bottom ]

Three monitors:
  -O:\tEnables only the selected monitor only
  -S:\tEnables only two monitors [MON1,MON2:P]"
    echo -e "\tMON1 and MON2 are monitor IDs given by the information option,"
    echo -e "\tP is the placement, [R] right or [B] bottom for MON2."
}

version() {
    echo -e "Mons 0.1b
Copyright (C) 2016 Thomas \"Ventto\" Venries.\n
License GPLv3+: GNU GPL version 3 or later
<http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE\n"
}

arg_err() {
    usage && exit 2
}

[ -f "/usr/bin/xrandr" ] && XRANDR="/usr/bin/xrandr"
[ -z "${XRANDR}" -a -f "/bin/xrandr" ] && XRANDR="/bin/xrandr"

enable_mon() {
    ${XRANDR} --display ${DISPLAY} --output ${1} --auto
}

disable_mons() {
    while [ "$#" -ne 0 ] ; do ${XRANDR} --output ${1} --off ; shift ; done
}

arg2xrandr() {
    case $1 in
        left)   echo "--left-of"    ;;
        right)  echo "--right-of"   ;;
        bottom) echo "--below"      ;;
        top)    echo "--above"      ;;
    esac
}

main() {
    local dFlag=false
    local eFlag=false
    local oFlag=false
    local sFlag=false
    local OFlag=false
    local SFlag=false
    local is_flag=false

    local eArg
    local OArg
    local SArg

    OPTIND=1
    while getopts "hvosde:O:S:" opt; do
        case $opt in
            h)  usage && exit ;;
            v)  version && exit ;;
            o)  $is_flag && arg_err
                oFlag=true ; is_flag=true
                ;;
            s)  $is_flag && arg_err
                sFlag=true ; is_flag=true
                ;;
            d)  $is_flag && arg_err
                dFlag=true ; is_flag=true
                ;;
            e)  $is_flag && arg_err
                case ${OPTARG} in left | right | bottom | top) ;; *) arg_err ;; esac
                eArg=$OPTARG
                eFlag=true ; is_flag=true
                ;;
            O)  $is_flag && arg_err
                ! [[ "${OPTARG}" =~ "^[0-9]+" ]] && arg_err
                OFlag=true ; is_flag=true
                ;;
            P)  $is_flag && arg_err
                [[ ! "${OPTARG:0:1}" =~ ^[0-9]+$ ]]    && arg_err
                [[ ! "${OPTARG:2:1}" =~ ^[0-9]+$ ]]    && arg_err
                [[ ! "${OPTARG:4:1}" =~ ^[RB]$ ]]      && arg_err
                [ "${OPTARG:0:1}" == "${OPTARG:2:1}" ] && arg_err
                SArg=$OPTARG
                SFlag=true ; is_flag=true
                ;;
            \?) usage && exit ;;
            :)  usage && exit ;;
        esac
    done

    [ -z "${DISPLAY}" ] && echo "X: server not started."     && exit 1
    [ -z "${XRANDR}" ]  && echo "xrandr: command not found." && exit 1

    local xrandr_out="$(${XRANDR} | grep connect)"

    [ -z "${xrandr_out}" ] && echo "No connected monitor." && exit

    local enabled_out="$(echo "${xrandr_out}" | grep -E "\+[0-9]{1,4}\+[0-9]{1,4}")"
    local mons=( $(echo "${xrandr_out}" | cut -d ' ' -f 1) )
    local plugged_mons=( $(echo "${xrandr_out}" | grep ' connect'| cut -d " " -f 1) )
    local enabled_mons=( $(echo "${enabled_out}" | cut -d " " -f 1) )

    if [ "$#" -eq 0 ]; then
        for ((i=0; i < ${#mons[@]}; i++)); do
            echo -n "${i}: ${mons[$i]}"
            if [[ "${plugged_mons[@]}" =~ "${mons[$i]}" ]] ; then
                if [[ "${enabled_mons[@]}" =~ "${mons[$i]}" ]] ; then
                    echo -e "\t(plugged)"
                else
                    echo -e "\t(enabled)"
                fi
            else
                echo
            fi
        done
        exit
    fi

    if $oFlag ; then
        if [ "${#plugged_mons[@]}" -eq 1 ] ; then
            ${XRANDR} --auto
        else
            if [ "${#enabled_mons[@]}" -eq 1 ] ; then
                if [ "${enabled_mons[0]}" == "${plugged_mons[0]}" ] ; then
                    enable_mon ${plugged_mons[0]}
                    exit $?
                fi
            fi
            bin_mons=( "${enabled_mons[@]/${plugged_mons[0]}}" )
            disable_mons "${bin_mons[@]}"
            enable_mon ${plugged_mons[0]}
        fi
        exit $?
    fi

    if [ "${#plugged_mons[@]}" -eq 1 ] ; then
        echo "Only one monitor detected."
        exit
    fi

    if [ "${#enabled_mons[@]}" -gt 2 ]; then
        echo "Can not handle more than two monitors."
        exit
    fi

    if ( $dFlag || $eFlag || $sFlag ) && [ "${#plugged_mons[@]}" -gt 2 ] ; then
        echo "At most two plugged monitors for this option."
        exit
    fi

    if $dFlag ; then
        ${XRANDR} --auto && \
         ${XRANDR} --output ${plugged_mons[1]} --same-as ${plugged_mons[0]}
        exit $?
    fi

    if $eFlag ; then
        ${XRANDR} --auto && \
         ${XRANDR} --output ${plugged_mons[1]} $(arg2xrandr ${eArg}) ${plugged_mons[0]}
        exit $?
    fi

    if $sFlag ; then
        if [ "${#enabled_mons[@]}" -eq 1 ] ; then
            if [ "${enabled_mons[0]}" == "${plugged_mons[1]}" ] ; then
                enable_mon ${plugged_mons[1]}
                exit
            fi
        fi
        enable_mon ${plugged_mons[1]} && \
        disable_mons ${enabled_mons[0]}
        exit
    fi

    if [ "${#plugged_mons[@]}" -lt 3 ] ; then
        echo "At least three plugged monitors for this option."
        exit 0
    fi

    if $SFlag ; then
        local mon1="${SArg:0:1}"
        local mon2="${SArg:2:1}"
        local area="${SArg:4:1}"

        if [ "${mon1}" -ge "${#mons[@]}" || "${mon2}" -ge "${#mons[@]}" ]; then
            echo "One or both selected monitors do not exist."
            exit 2
        fi
        if [[ ! "${plugged_mons[@]}" =~ "${mons[${mon1}]}" ]] ; then
            echo "One or both selected monitors are not plugged in."
            exit 2
        fi
        if [[ ! "${plugged_mons[@]}" =~ "${mons[${mon2}]}" ]] ; then
            echo "One or both selected monitors are not plugged in."
            exit 2
        fi

        [ "${area}" == "R" ] && area="--right-of" || area="--above"

        bin_mons=( "${enabled_mons[@]/${mons[${mon1}]}/${mons[${mon2}]}}" )
        disable_mons "${bin_mons[@]}"
        ${XRANDR} --output ${mon2} ${area} ${mon1}
        exit
    fi

    if [ "${#enabled_mons[@]}" -ne 2 ] ; then
        echo "At least two enabled monitors for this option."
        exit
    fi

    if $OFlag ; then
        if [ "${OArg}" -ge "${#mons[@]}" ] ; then
            echo "Selected monitor does not exist."
            exit 2
        fi
        if ! [[ "${plugged_mons[@]}" =~ "${mons[${OArg}]}" ]] ; then
            echo "Selected monitors is not plugged in."
            exit 2
        fi
        disable_mons ${enabled_mons[@]}
        enable_mon ${mons[${OArg}]}
    fi
}

main "$@"
