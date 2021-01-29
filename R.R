# Enum
cell <- function(){
    list(ALIVE = 1, DEAD = 0)
}

extend <- function(arr, n, elem){
    range <- (length(arr)+1):(length(arr)+n)
    for (i in range){ arr[i] <- elem }
    return(arr)
}

initboard <- function(str, h, w){
    # split char
    newarr <- sapply(str, function(x)
        substring(x,seq(1,nchar(x),1),seq(1,nchar(x),1))
    )
    newarr <- apply(newarr, 2, function(row)
        sapply(row, function(c)
           if (c == '#'){ return( cell()$ALIVE )
           }else{ return( cell()$DEAD ) }
        )
    )
    dimnames(newarr) <- NULL
    for (i in 1:(w-length(newarr[1,])) )
        { newarr <- cbind(newarr, extend(c(),length(str),0)) }
    for (i in 1:(h-length(str)) )
        { newarr <- rbind(newarr, extend(c(),w,0)) }
    return(newarr)
}


showBoard <- function(board, aliveChar, deadChar){
    showboard <- apply(board, 2, function(row)
        sapply(row, function(c)
           if (c == cell()$ALIVE ){ return(aliveChar)
           }else{ return(deadChar) }
        )
    )
    for (i in 1:dim(showboard)[1]){
        cat(showboard[i,], '\n', sep='')
    }
}


countNeighbour <- function(board, row, col){
    count <- 0
    if (board[row,col] == cell()$ALIVE ) { count <- -1 }
    for (dr in -1:1){ for (dc in -1:1){
        r <- 1+(row-1+dr)%%(length(board)%/%length(board[1,]))
        c <- 1+(col-1+dc)%%(length(board[1,]))
        if (board[r,c] == cell()$ALIVE) { count <- count+1 }
    }}
    return(count)
}

nextStage <- function(board, h, w){
    newboard <- board
    for (r in 1:h){ for(c in 1:w){
        n <- countNeighbour(board,r,c)
        if (board[r,c] == cell()$ALIVE){
            if ((n < 2) || (n > 3)) { newboard[r,c] <- cell()$DEAD }
        }else{
            if (n == 3) { newboard[r,c] <- cell()$ALIVE }
        }
    }}
    return(newboard)
}

height  <- 8
width   <- 10
initstr <- c(".#.",
             "..#",
             "###")
board <- initboard(initstr,height,width)
showBoard(board, '#', '.')

while(TRUE){
    board <-nextStage(board, height, width)
    cat('\033[',height,'A',sep='')
    showBoard(board, '#', '.')
    Sys.sleep(0.25)
}
