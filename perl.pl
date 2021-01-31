use warnings;
use strict;
use Time::HiRes;

sub initBoard {
    my ($h, $w, @arr) = @_;
    my @board;
    my @exp = map { $_ . "." x ($w - length $_) } @arr;
    for (scalar @arr .. $h - 1) { @exp[$_] = "." x $w; }
    for (0 .. $h - 1) { 
        my @row = map { if ($_ eq '#') {1} else {0} } split //, $exp[$_]; 
        push @board, \@row; 
    }
    return @board;
}

sub showBoard {
    my ($alChar, $deChar, @board) = @_;
    foreach my $row (@board){
        foreach my $cell (@$row){ if ($cell) {print $alChar} else {print $deChar}; }
        print "\n";
    }
}

sub countNeighbors {
    my ($row, $col, @board) = @_;
    my $height = scalar @board;
    my $fr_pt  = $board[0];
    my $width  = scalar @$fr_pt;
    my $count  = 0;
    if ($board[$row][$col]) {$count = -1};
    foreach my $dr (-1..1){ foreach my $dc (-1..1){
        my $r = ($row + $dr) % $height;
        my $c = ($col + $dc) % $width;
        if ($board[$r][$c]) {$count = $count + 1};
    } }
    return $count;
}

sub nextStage {
    my @board = @_;
    my $height = scalar @board;
    my $fr_pt  = $board[0];
    my $width  = scalar @$fr_pt;
    my @next = initBoard($height, $width, ());
    foreach my $r (0..$height-1){ foreach my $c (0..$width-1){
        my $n = countNeighbors($r, $c, @board);
        if ($board[$r][$c] == 1){ if ( 2 <= $n and $n <= 3 ) { $next[$r][$c] = 1 } }
        else{ if ( $n == 3 ) { $next[$r][$c] = 1 } }
    } }
    return @next;
}


open my $inputFile, '<', "input.txt" or die $!;
chomp (my ($header, @initstr) = <$inputFile>);
close $inputFile;

my ($height, $width) = split ' ', $header; 
my @world = initBoard($height, $width, @initstr);
showBoard('#', '.', @world);
for (0..1000){
    @world = nextStage(@world);
    print "\033[${height}A";
    showBoard('#', '.', @world);
    Time::HiRes::usleep(250000);
}
