const cell = {
    DEAD  : false,
    ALIVE : true
};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function initBoard(str, h, w){
    let fromstr = str.map( row => Array.from(row).map( c =>
        c == '#' ? cell.ALIVE : cell.DEAD));
    while (fromstr.length < h) fromstr.push([]);
    for (row in fromstr) while (fromstr[row].length < w) fromstr[row].push(cell.DEAD);
    return fromstr;
};

function showBoard(board, aliveChr, deadChr){
    return board.map( row => 
        row.map( c => c == cell.ALIVE ? aliveChr : deadChr).join('') )
            .join('\n');
};

function countNeighbors(board, row, col){
    let height = board.length;
    let width  = board[0].length;
    let count  = 0;
    if (board[row][col] == cell.ALIVE) count -= 1;
    for (let i = -1; i <= 1; i++) for (let j = -1; j <= 1; j++)
        if (board[(row+i+height)%height][(col+j+width)%width] == cell.ALIVE)
            count += 1;
    return count;
};

function nextStage(board){
    let height = board.length;
    let width  = board[0].length;
    let next   = initBoard([],height,width);
    for (let i = 0; i < height; i++) for (let j = 0; j < width; j++){
        let n = countNeighbors(board, i, j);
        if (board[i][j] == cell.ALIVE) next[i][j] = ((n<2) || (n>3)) ? cell.DEAD : cell.ALIVE;
        else if (board[i][j] == cell.DEAD) next[i][j] = n == 3 ? cell.ALIVE : cell.DEAD;
    }
    return next;
};

async function main(){
    let height = 8;
    let width = 10;
    let initstr = [
        '.#.',
        '..#',
        '###'
    ];
    let world = initBoard(initstr, height, width);
    console.log(showBoard(world,'#','.'));
    for (let i = 0; i < 9999; i++){
        console.log('\033'+`[${height+1}A`);
        world = nextStage(world);
        console.log(showBoard(world,'#','.'));
        await sleep(250);
    }
};

main();
