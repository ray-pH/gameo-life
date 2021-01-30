public class java {
    enum Cell { DEAD, ALIVE }

    public static void wait(int ms){
        try { Thread.sleep(ms); }
        catch(InterruptedException ex){
            Thread.currentThread().interrupt();
        }
    }

    public static Cell[][] initBoard(String[] strarr, int h, int w){
        Cell[][] board = new Cell[h][w];
        for (int i = 0; i < h; i++)
            for (int j = 0; j < w; j++) board[i][j] = Cell.DEAD;
        for (int i = 0; i < strarr.length; i++){
            for (int j = 0; j < strarr[i].length(); j++){
                if (strarr[i].charAt(j) == '#') board[i][j] = Cell.ALIVE;
            }
        }
        return board;
    }

    public static void showBoard(Cell[][] board, char aliveC, char deadC){
        for (Cell[] row : board) {
            for (Cell cell : row) 
                if (cell == Cell.ALIVE) { System.out.print(aliveC); }
                else { System.out.print(deadC); }
            System.out.println();
        }
    }

    public static int countNeighbors(Cell[][] board, int row, int col){
        int height = board.length;
        int width  = board[0].length;
        int count  = 0;
        if (board[row][col] == Cell.ALIVE) count = -1;
        for (int dr = -1; dr <= 1; dr++){
            for (int dc = -1; dc <= 1; dc++){
                int r = (row + dr + height) % height;
                int c = (col + dc + width ) % width ;
                if (board[r][c] == Cell.ALIVE) count += 1;
            }
        }
        return count;
    }

    public static Cell[][] nextStage(Cell[][] board){
        int height = board.length;
        int width  = board[0].length;
        Cell[][] next = initBoard(new String[0],height,width);
        for (int i = 0; i < height; i++){
            for (int j = 0; j < width; j++){
                int n = countNeighbors(board, i, j);
                if ((board[i][j] == Cell.ALIVE && n >= 2 && n <= 3) || n == 3) next[i][j] = Cell.ALIVE;
            }
        }
        return next;
    }

    public static void main(String[] args){
        int height = 8;
        int width  = 10;
        char aliveChar   = '#';
        char deadChar    = '.';
        String[] initstr = {
            ".#.",
            "..#",
            "###"
        };
        Cell[][] world = initBoard(initstr, height, width);
        showBoard(world, aliveChar, deadChar);
        while (true) {
            world = nextStage(world);
            System.out.print("\033[" + Integer.toString(height) + "A");
            showBoard(world, aliveChar, deadChar);
            wait(250);
        }
    }
}

