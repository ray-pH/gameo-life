@enum Cell Dead Alive

function initBoard(strarr, h, w)
    board = [[Dead for _ in 1:w] for _ in 1:h]
    for i in 1:length(strarr) for j in 1:length(strarr[i])
            (strarr[i][j] == '#') && (board[i][j] = Alive)
    end end
    return board
end

function showBoard(board, aliveC, deadC)
    for row in board 
        for cell in row print( ifelse(cell==Alive, aliveC, deadC)) end
        println()
    end
end

function countNeighbors(board, row, col)
    count  = ifelse(board[row][col] == Alive, -1, 0)
    height = length(board)
    width  = length(board[1])
    for dr in -1:1 for dc in -1:1
        r = 1 + (row + dr + height - 1) % height 
        c = 1 + (col + dc + width - 1) % width
        (board[r][c] == Alive) && (count += 1)
    end end
    return count
end

function nextStage(board)
    height = length(board)
    width  = length(board[1])
    next   = initBoard([[]], height, width)
    for i in 1:height for j in 1:width
        n = countNeighbors(board, i, j)
        ( (board[i][j]==Alive && 2 <= n <= 3) || n == 3 ) && ( next[i][j] = Alive )
    end end
    return next
end

inputFile = open("input.txt", "r")

height, width = [parse(Int,x) for x in split(readline(inputFile), " ")]
initstr = []
while ! eof(inputFile) push!(initstr, readline(inputFile)) end
close(inputFile)

world = initBoard(initstr, height, width)
showBoard(world, '#', '.')
while true
    global world
    world = nextStage(world)
    print("\033[",height,"A")
    showBoard(world, '#', '.')
    sleep(0.25)
end
