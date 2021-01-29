use std::{thread, time};

#[derive(Copy, Clone, Debug, PartialEq)]
enum Cell { ALIVE, DEAD, }

fn init_board(strvec:Vec<&str>, h:usize, w:usize) -> Vec<Vec<Cell>> {
    let mut board : Vec<Vec<Cell>> = vec![vec![Cell::DEAD; w]; h];
    for i in 0..strvec.len(){ for j in 0..strvec[i].len(){
        if strvec[i].chars().nth(j).unwrap() == '#' { board[i][j] = Cell::ALIVE; }
    } }
    return board;
}

fn show_board(board:&Vec<Vec<Cell>>, alive_char:char, dead_char:char){
    for row in board { 
        for cell in row { print!("{}",if cell == &Cell::ALIVE {alive_char} else {dead_char} ); } 
        println!();
    }
}

fn count_neighbors(board:&Vec<Vec<Cell>>, row:usize, col:usize) -> usize {
    let height : i32 = board.len() as i32;
    let width  : i32 = board[0].len() as i32;
    let mut count : usize = 0;
    for dr in -1..2 { for dc in -1..2 {
        let r : usize = (((row as i32) + dr + height) % height) as usize;
        let c : usize = (((col as i32) + dc + width ) % width ) as usize;
        if board[r][c] == Cell::ALIVE { count += 1; } 
    } }
    if board[row][col] == Cell::ALIVE { count -= 1; }
    return count;
}

fn next_stage(board:Vec<Vec<Cell>>) -> Vec<Vec<Cell>> {
    let height : usize = board.len();
    let width  : usize = board[0].len();
    let mut nboard : Vec<Vec<Cell>> = vec![vec![Cell::DEAD; width]; height];
    for i in 0..height { for j in 0..width {
        let n : usize = count_neighbors(&board, i, j);
        if board[i][j] == Cell::ALIVE && n >= 2 && n <= 3 { nboard[i][j] = Cell::ALIVE; }
        if board[i][j] == Cell::DEAD  && n == 3 { nboard[i][j] = Cell::ALIVE; }
    } }
    return nboard;
}

fn main(){
    let height : usize = 8;
    let width  : usize = 10;
    let initstr : Vec<&str> = vec![
        ".#.",
        "..#",
        "###"
    ];
    let mut world : Vec<Vec<Cell>> 
        = init_board(initstr, height, width);
    show_board(&world, '#', '.');
    loop {
        world = next_stage(world);
        print!("\x1B[8A");
        show_board(&world, '#', '.');
        thread::sleep(time::Duration::from_millis(250));
    }
}
