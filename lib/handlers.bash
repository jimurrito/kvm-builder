#!/bin/bash
#
# Fail Check Function
fc() {
    if [[ -n $1 ]]; then echo "$2 ErrorMsg($1)"; exit 1; fi
}
# Fail Check - NO KILL - Function
fcnk() {
    if [[ -n $1 ]]; then echo "$2 ErrorMsg($1)"; fi
}
# Empty Check Function
ec() {
    if [[ -z $1 ]]; then echo "$2"; exit 1; fi
}