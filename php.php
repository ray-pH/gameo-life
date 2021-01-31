<?php

abstract class Cell{
    const Alive = 1;
    const Dead  = 0;
}

function initBoard($strarr, $height, $width){
    $board = array();
    for ($i = 0; $i < $height; $i++){
        $board[$i] = array();
        for ($j = 0; $j < $width; $j++) $board[$i][$j] = Cell::Dead;
    }
    for ($i = 0; $i < count($strarr); $i++){
        for ($j = 0; $j < strlen($strarr[$i]); $j++)
            if ($strarr[$i][$j] == '#') $board[$i][$j] = Cell::Alive;
    }
    return $board;
}

function showBoard($board, $aliveChar, $deadChar){
    foreach ($board as $row)  {
        foreach($row as $cell)
            echo ($cell == Cell::Alive) ? $aliveChar : $deadChar;
        echo "\n";
    }
}

function countNeighbors($board, $row, $col){
    $count  = 0;
    $height = count($board);
    $width  = count($board[0]);
    if ($board[$row][$col] == Cell::Alive) $count -= 1;
    for ($i = -1; $i <= 1; $i++) for ($j = -1; $j <= 1; $j++)
        if ($board[($i+$row+$height)%$height][($j+$col+$width)%$width] == Cell::Alive)
            $count += 1;
    return $count;
}

function nextState($board){
    $next = $board;
    for ($i = 0; $i < count($board); $i++)
        for ($j = 0; $j < count($board[$i]); $j++){
            $n = countNeighbors($board, $i, $j);
            switch ($board[$i][$j]){
            case Cell::Alive : if (($n < 2) or ($n > 3)) $next[$i][$j] = Cell::Dead;
            case Cell::Dead  : if ($n == 3) $next[$i][$j] = Cell::Alive;
            }
        }
    return $next;
}

$inputFile = fopen("input.txt", "r") or die("err file");
$header    = explode(" ", fgets($inputFile));
$initstr   = explode("\n", fread($inputFile, filesize("input.txt")));
fclose($inputFile);

$height    = $header[0];
$width     = $header[1];

$world     = initBoard($initstr, $height, $width);
showBoard($world, '#', '.');
while (true){
    echo "\033[{$height}A";
    $world   = nextState($world);
    showBoard($world, '#', '.');
    usleep(250000);
}
?>
