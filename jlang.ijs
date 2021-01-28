dot =. '.'

NB. g =. 13 : ',/ ((":)"0) y' 
g =. [: ,/ ":"0

NB. delay
delay=: 3 : 0
c=: y
c=: 3000 * c  NB. 400 5 sec
while. c > 0 do. c=: c - 1
c
end.
)

NB. converter
conv =: 3 : 0
if. y = 1 do. '#'
else. '.'
end.
)

NB. tr =. 13 : 'y,(x-#y)$dot' add trailing
trail =. ],'.'$~[-[:#]
istr =. 3 3 $ '.#.', '..#', '###'
tabl =. 8 10 $ '.'
h =: 0 { $ tabl
w =: 1 { $ tabl
NB. all rows and columns
rowcols =: (i.h) ,"0/ i.w
NB. mask to remove center
mask =: 3 3 $ 1 1 1 1 0 1

NB. get element from index c -> (row col)
gelem =: 13 : '(w|(1{x)) { (h|(0{x)) {y'

NB. completing string
board =: (w trail ])"1 istr 
board =: h$ board,tabl
board =: '#' = board

NB. deltas -1 0 1
deltas =: ,"0/~<:i.3
NB. neighbors coordinates
neigh_coords_f =. 3 : ' (y+])"1 deltas '
neigh_coords =: neigh_coords_f"1 rowcols
NB. sumf =. 13:'+/+/y'
sumf =: [:+/+/


echo conv"0 board

3 : 0''
while. 1 do.
    NB. dsrc coord -> (row col)
    neighbors =.  (board gelem~ ])"1 neigh_coords
    neigh_val =. (mask * ])"2 (1 = neighbors)
    NB. neighbors count
    ns =. sumf"2 neigh_val

    al_map =. 1 = board
    de_map =. 0 = board
    al_n =. al_map * ns
    de_n =. de_map * ns

    al_next =. ((1&<)*(4&>)) al_n
    de_next =. de_n = 3
    board_next =. al_next + de_next
    NB. echo '\033[8D'
    msg =. 27,91,(48+h+1),65
    echo u:msg
    echo conv"0 board_next
    delay 400

    board =: board_next
end.
)

exit ''
