package main

import (
    "fmt"
    "time"
)

type Cell int
const ( 
    DEAD = iota
    ALIVE
)
type Board [][]Cell

func initBoard(strarr []string, h, w int) Board {
    var board = make([][]Cell, h)
    for i := 0; i < h; i++ { board[i] = make([]Cell, w) }
    for i := 0; i < len(strarr); i++{
        for j := 0; j < len(strarr[i]); j++{ 
            if strarr[i][j] == '#' { board[i][j] = ALIVE }
        }
    }
    return board
}

func showBoard(board Board, aliveC, deadC rune){
    for _,row := range board{
        for _,cell := range row{
            if cell == ALIVE { fmt.Print(string(aliveC)) } else { fmt.Print(string(deadC)) }
        } 
        fmt.Println()
    }
}

func countNeighbors(board Board, row, col int) int{
    var h = len(board)
    var w = len(board[0]) 
    var count = 0
    if board[row][col] == ALIVE { count -= 1 }
    for dr := -1; dr <= 1; dr++{ for dc := -1; dc <= 1; dc++{
        var r = (row + dr + h) % h
        var c = (col + dc + w) % w
        if board[r][c] == ALIVE { count += 1 }
    } }
    return count
}

func nextStage(board Board) Board{
    var h = len(board)
    var w = len(board[0])
    var next = initBoard(make([]string,0), h, w)
    for r := 0; r < h; r++{ for c := 0; c < w; c++{
        var n = countNeighbors(board, r, c)
        if ( board[r][c] == ALIVE && n >= 2 && n <= 3 ) || n == 3 {
            next[r][c] = ALIVE
        }
    } }
    return next
}

func main() {
    var height int = 8
    var width  int = 10
    var initstr = []string{
        ".#.",
        "..#",
        "###",
    }
    var world Board = initBoard(initstr, height, width)
    showBoard(world, '#', '.')
    for i := 0; i < 10000; i++{
        world = nextStage(world)
        fmt.Printf("\033[%dA", height)
        showBoard(world, '#', '.')
        time.Sleep(250 * time.Millisecond)
    }
}
