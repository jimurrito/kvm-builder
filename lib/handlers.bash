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

# Size Selector
size_find() {
    # ${1,,} sets input to lower case
    case ${1,,} in
        # A
        "a")
            OUT=(1 1)     
        ;;
        # AA
        "aa")
            OUT=(1 2)   
        ;;
        # B
        "b")
            OUT=(2 2)  
        ;;
        # BB
        "bb")
            OUT=(2 4)   
        ;;
        # C
        "c")
            OUT=(4 2)
        ;;
        # CC
        "cc")
            OUT=(4 4)
        ;;
        # D
        "d")
            OUT=(4 6) 
        ;;
        # DD
        "dd")
            OUT=(4 8)
        ;;
        # E
        "e")
            OUT=(6 4)
        ;;
        # EE
        "ee")
            OUT=(6 8) 
        ;;
        # Catch-all
        *)
            OUT=false
    esac
    #
    echo "${OUT[@]}"
}