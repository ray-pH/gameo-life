module game_of_life_module
    use, intrinsic :: iso_c_binding, only: c_int

    implicit none
    integer, parameter :: alive = 1, dead = 0

    interface
        subroutine usleep (micro_seconds)  bind ( C, name="usleep" )
            import
            integer (c_int), intent (in), VALUE :: micro_seconds
        end subroutine
    end interface

contains

    subroutine sleep_millis(milli_seconds)
        integer, intent(in) :: milli_seconds

        call usleep(milli_seconds*1000)

    end subroutine

    subroutine showBoard(b)
        integer, intent(in) :: b(:,:)
        integer :: i, j

        do i = 1, size(b, dim=1)
            do j = 1, size(b, dim=2)
                if (b(i, j) == alive) then
                    write(*, '(A)', advance='no') '#'
                else
                    write(*, '(A)', advance='no') '.'
                end if
            end do
            print *  ! Newline
        end do
    end subroutine showBoard

    function countNeighbors(b, row, col) result(n)
        integer, intent(in) :: row, col
        integer, intent(in) :: b(:, :)
        integer :: h, w
        integer :: i, j, ni, nj, n

        h = size(b, dim=1)
        w = size(b, dim=2)

        n = 0
        if (b(row, col) == alive) n = n - 1

        do i = -1, 1
            do j = -1, 1
                ni = mod(row + i - 1 + h, h) + 1
                nj = mod(col + j - 1 + w, w) + 1
                if (b(ni, nj) == alive) n = n + 1
            end do
        end do
    end function countNeighbors

    function nextState(oldboard) result(newboard)
        integer, intent(in) :: oldboard(:,:)
        integer, allocatable :: newboard(:,:)
        integer :: i, j, neighbors

        newboard = oldboard
        do i = 1, size(oldboard, dim=1)
            do j = 1, size(oldboard, dim=2)
                neighbors = countNeighbors(oldboard, i, j)
                if ((oldboard(i, j) == alive) .and. ((neighbors < 2) .or. (neighbors > 3))) then
                    newboard(i, j) = dead
                else if ((oldboard(i, j) == dead) .and. (neighbors == 3)) then
                    newboard(i, j) = alive
                end if
            end do
        end do
    end function nextState

    function intToStr(i) result(s)
        integer, intent(in) :: i
        character(len=10) :: s
        write(s, '(I0)') i
    end function intToStr

end module game_of_life_module

program game_of_life
    use game_of_life_module
    implicit none
    integer :: height, width
    integer, allocatable :: board(:,:)
    character(len=100) :: line
    integer :: i, j, eof, unit

    ! Read input from "input.txt"
    open(newunit=unit, file="input.txt", status="old", action="read")
    read(unit, *) height, width

    allocate(board(height, width))
    board = dead

    do i = 1, height
        read(unit, '(A)', iostat=eof) line
        if (eof < 0) exit
        do j = 1, len_trim(line)
            if (line(j:j) == '#') board(i,j) = alive
        end do
    end do
    close(unit)

    ! Display initial state
    call showBoard(board)

    ! Game loop
    do
        print *, CHAR(27) // "[" // TRIM(ADJUSTL(intToStr(height+1))) // "A"
        board = nextState(board)
        call showBoard(board)
        call sleep_millis(250)
    end do

end program game_of_life
