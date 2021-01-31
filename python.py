import enum, time

class Cell(enum.Enum):
    Alive  = True
    Dead   = False

def initBoard(st, height, width):
    board = [[Cell.Dead for _ in range(width)] for _ in range(height)]
    for i in range(len(st)):
        for j in range(len(st[0])):
            if st[i][j] == '#' : 
                board[i][j] = Cell.Alive
    return board

def writeBoard(board, aliveChar, deadChar):
    for row in board:
        for cell in row:
            print(
                aliveChar if cell==Cell.Alive else deadChar,
                end = '')
        print()

def countNeighbors(board, row, col):
    count  = 0
    height = len(board)
    width  = len(board[0])
    if board[row][col] == Cell.Alive : count -= 1
    for i in range(-1,2):
        for j in range(-1,2):
            if board[(row+i)%height][(col+j)%width] == Cell.Alive:
                count += 1
    return count

def nextState(board):
    newboard = []
    def newstate(state, n):
        if state == Cell.Alive and n not in [2,3] : return Cell.Dead
        elif state == Cell.Dead and n == 3 : return Cell.Alive
        else : return state
    for i in range(len(board)):
        row = []
        for j in range(len(board[i])):
            row.append(newstate(board[i][j],countNeighbors(board,i,j)))
        newboard.append(row)
    return newboard


def main():
    initstr = []

    f = open('input.txt','r')
    height , width = map(lambda x : int(x), f.readline().split(' '))
    for row in f : initstr.append(row[:-1])
    f.close()

    world   = initBoard(initstr, height, width)
    writeBoard(world,'#','.')
    while True:
        world   = nextState(world)
        print(f"\033[{height+1}A")
        writeBoard(world,'#','.')
        time.sleep(0.25)

if __name__ == "__main__":
    main()

