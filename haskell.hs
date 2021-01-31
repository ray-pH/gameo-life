import Control.Concurrent
import System.IO

data Cell = Alive | Dead
    deriving (Show, Eq)
type Board = [[Cell]]

expandRow :: Int -> [String] -> [String]
expandRow hei strarr
    | length strarr >= hei = strarr
    | otherwise = expandRow hei $ strarr ++ [""]

expandCol :: Int -> String -> String
expandCol wid str
    | length str >= wid = str
    | otherwise = expandCol wid $ str ++ "."

expandStr :: [String] -> Int -> Int -> [String]
expandStr strarr hei wid = map (expandCol wid) $ expandRow hei strarr

initBoard :: [String] -> Int -> Int -> Board
initBoard strarr hei wid = map (map toCell) $ expandStr strarr hei wid
    where toCell :: Char -> Cell
          toCell c = if c == '#' then Alive else Dead

showBoard :: Char -> Char -> Board -> String
showBoard aliveChar deadChar board = 
    combineString $ map (map toChar) board
        where toChar :: Cell -> Char
              toChar c = if c == Alive then aliveChar else deadChar
              combineString :: [String] -> String
              combineString [] = ""
              combineString (s:ss) = s ++ "\n" ++ combineString ss

countNeighbors :: Board -> Int -> Int -> Int
countNeighbors board row col =
    let height = length board
        width  = length $ head board
        neighcoords = [(mod (row+i) height, mod (col+j) width) 
          | i <- [-1..1], j <- [-1..1], i/=0 || j/=0 ]
     in length $ filter (== Alive) $ [board!!r!!c | (r,c) <- neighcoords]

rule :: (Int,Cell) -> Cell
rule (n,cell) 
    | cell == Alive = if elem n [2,3] then Alive else Dead
    | cell == Dead  = if n == 3       then Alive else Dead

nextStage :: Board -> Board
nextStage board = let zipped   = zip [0..] $ map (zip [0..]) board
                      zipped'  = map concatZip zipped
                      zipped'' = map (map getNeighbor) zipped' 
                   in map (map rule) zipped''
    where concatZip :: (Int, [(Int, Cell)]) -> [(Int,Int,Cell)]
          concatZip (row, arr) = [(row,col,c) | (col,c) <- arr]
          getNeighbor :: (Int,Int,Cell) -> (Int,Cell)
          getNeighbor (row,col,cell) = (countNeighbors board row col, cell)

gol :: Board -> (Int,Int) -> IO()
gol prev (h,w) = do
    let next   = nextStage prev 
        cursor = "\ESC[" ++ show(h) ++ "A"
    putStr $ cursor ++ showBoard '#' '.' next
    threadDelay 250000
    gol next (h,w)

split :: Eq a => a -> [a] -> [[a]]
split d [] = []
split d s = x : split d (drop 1 y) where (x,y) = span (/= d) s

mapTuple :: (a -> b) -> (a, a) -> (b, b)
mapTuple f (a1, a2) = (f a1, f a2)

main :: IO()
main = do
    file <- openFile "input.txt" ReadMode
    cont <- hGetContents file
    let (header : initStr) = lines cont
        (height, width)    = mapTuple (read :: String -> Int) $ span (/= ' ') header
        initb   = initBoard initStr height width
    putStr $ showBoard '#' '.' initb 
    gol initb (height, width)
