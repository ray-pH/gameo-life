#!/bin/bash

dead=0
alive=1

# initarr, height, width
initBoard () {
    local -n strarr=$1
    local -n board=$2
    for i in $(eval echo {0..$(($height - 1))}); do
        for j in $(eval echo {0..$(($width - 1))}); do
            board[$i,$j]=$dead;
        done;
    done
    for i in $(eval echo {0..$((${#strarr[@]} - 1))}); do
        for j in $(eval echo {0..$((${#strarr[$i]} - 1))}); do
            local row=${initstr[$i]}
            local char=${row:$j:1}
            if [ $char == '#' ] ; then board[$i,$j]=$alive; fi
        done;
    done
}

copyBoard () {
    local -n prev=$1
    local -n next=$2
    for i in $(eval echo {0..$(($height - 1))}); do
        for j in $(eval echo {0..$(($width - 1))}); do
            next[$i,$j]=${prev[$i,$j]}
        done;
    done
}

showBoard () {
    local -n board=$1
    local aChar=$2
    local dChar=$3
    for i in $(eval echo {0..$(($height - 1))}); do
        for j in $(eval echo {0..$(($width - 1))}); do
            local cell=${board[$i,$j]}
            if [ $cell -eq $alive ] ; then printf $aChar;
            else printf $dChar;
            fi;
        done;
        printf '\n'
    done
}

# row, column, board
countNeighbors () {
    local r=$1
    local c=$2
    local count=0
    local -n board=$3
    if [ ${board[$r,$c]} -eq $alive ] ; then count=$(($count-1)); fi
    for i in {-1..1}; do
        for j in {-1..1}; do
            local x=$((($i + r + $height) % $height)) 
            local y=$((($j + c + $width ) % $width )) 
            if [ ${board[$x,$y]} -eq $alive ] ; then count=$(($count+1)); fi
        done
    done
    echo $count
}

nextStage () {
    local -n pboard=$1
    local -n nboard=$2
    for i in $(eval echo {0..$(($height - 1))}); do
        for j in $(eval echo {0..$(($width - 1))}); do
            local n=$(countNeighbors $i $j pboard)
            local cell=${pboard[$i,$j]}
            if [ $cell -eq $alive ]; 
            then
                if [ $n -lt 2 ] || [ $n -gt 3 ]; 
                then nboard[$i,$j]=$dead; else nboard[$i,$j]=$alive; fi
            else
                if [ $n -eq 3 ]; 
                then nboard[$i,$j]=$alive; else nboard[$i,$j]=$dead; fi
            fi;
        done;
    done
}

width=10
height=8
initstr=(".#." "..#" "###")
aliveChar='#'
deadChar='.'
declare -A world
declare -A newworld
initBoard initstr world
showBoard world $aliveChar $deadChar
# for i in {1..10}; do
while true; do
    nextStage world newworld
    echo -e "\033[$(($height + 1))A"
    showBoard newworld $aliveChar $deadChar
    copyBoard newworld world
done;
