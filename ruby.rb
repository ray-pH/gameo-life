# print no newline sync
$stdout.sync = true

# cell enum
:dead
:alive

def initBoard(strarr, h, w)
    board = (1..h).collect{ (1..w).collect{:dead} }
    (0..strarr.length-1).each{ |i| (0..strarr[i].length-1).each{ |j| 
        if strarr[i][j] == '#' then board[i][j] = :alive end
    } }
    return board
end

def showBoard(board, aliveChar, deadChar)
    board.each{ |row| row.each { |cell| 
        if cell == :alive then print aliveChar else print deadChar end }
        print "\n" 
    }
end

def countNeighbors(board, row, col)
    if board[row][col] == :alive then n = -1 else n = 0 end
    (-1..1).each{ |dr| (-1..1).each{ |dc|
        r = (row + dr) % board.length
        c = (col + dc) % board[0].length
        if board[r][c] == :alive then n += 1 end
    } }
    return n
end

def nextStage(board)
    newb = board.clone.map(&:clone)
    (0..board.length-1).each{ |row| (0..board[row].length-1).each { |col|
        n = countNeighbors(board, row, col)
        if board[row][col] == :alive and (n < 2 or n > 3) then newb[row][col] = :dead
        else if n == 3 then newb[row][col] = :alive end end
    } }
    return newb
end

height = 8
width  = 10
initstr = [
    ".#.",
    "..#",
    "###"
]

world = initBoard(initstr, height, width)
showBoard(world, '#', '.')
while true
    world = nextStage(world)
    print "\033[#{height}A"
    showBoard(world, '#', '.')
    sleep(0.25)
end
