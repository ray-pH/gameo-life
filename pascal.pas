program gol;
uses crt;
type
    Cell  = (dead, alive);
    Board = Array of Array of Cell;

function initialBoard(starr : Array of AnsiString; h, w : Integer) : Board;
var 
    res  : Board;
    i, j : Integer;
begin
    SetLength(res, h, w);
    for i := 0 to h - 1 do for j := 0 to w - 1 do res[i,j] := dead;
    for i := 0 to Length(starr)-1 do
        for j := 1 to Length(starr[i]) do 
            if starr[i,j] = '#' then res[i,j-1] := alive;
    Exit(res);
end;

function countNeighbors(b : Board; row, col : Integer) : Integer;
var i, j, h, w : Integer;
begin
    countNeighbors := 0;
    h := Length(b); w := Length(b[0]);
    if b[row, col] = alive then countNeighbors -= 1;
    for i := -1 to 1 do for j := -1 to 1 do
       if b[(row+i+h) mod h, (col+j+w) mod w] = alive then countNeighbors += 1;
end;

function nextState(b : Board) : Board;
var 
    i, j, n : Integer;
    newb    : Board;
begin
    SetLength(newb, Length(b), Length(b[0]));
    for i := 0 to Length(b)-1 do newb[i] := Copy(b[i]);
    for i := 0 to Length(newb) - 1 do
        for j := 0 to Length(newb[i]) - 1 do begin
            n := countNeighbors(b, i, j);
            if (b[i,j] = alive) and ((n < 2) or (n > 3)) then
                newb[i,j] := dead
            else if (b[i,j] = dead) and (n = 3) then
                newb[i,j] := alive;
        end;
    Exit(newb);
end;

procedure showBoard(b : Board; chrAlive, chrDead : Char);
var i, j : Integer;
begin
    for i := 0 to Length(b)-1 do begin
        for j := 0 to Length(b[i])-1 do
            if b[i,j] = alive then write(chrAlive) else write(chrDead);
        writeln();
    end;
end;

var
    { constants  }
    height   : Integer = 8;
    width    : Integer = 10;
    chrAlive : Char    = '#';
    chrDead  : Char    = '.';
    initstr  : Array of AnsiString 
             = ('.#.',
                '..#',
                '###');
    world    : Board;
begin
    world := initialBoard(initstr, height, width);
    showBoard(world, chrAlive, chrDead);
    while True do begin
        write(#27, '[', height, 'A');
        write(#27, '[', width , 'D');
        world := nextState(world);
        showBoard(world, chrAlive, chrDead);
        delay(250);
        if KeyPressed and (Readkey = ^C) then break;
    end;
end.
