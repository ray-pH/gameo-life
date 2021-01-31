#include<iostream>
#include<vector>
#include<fstream>
#include<sstream>

#ifdef _WIN32
    #include <windows.h>
#else
    #include <unistd.h>
#endif // _WIN32
using namespace std;

enum cell { dead, alive };
typedef vector<vector<cell>> board;

void sleep(int millis) {
    #ifdef _WIN32
        Sleep(millis);
    #else
        usleep(millis * 1000);
    #endif 
}

void showBoard(board b, char aliveChar, char deadChar){
    for (vector<cell> row : b){
        for (cell c : row) cout << ((c == alive) ? aliveChar : deadChar);
        cout << endl;
    }
}

board initBoard(vector<string> strvec, int h, int w){
    board init(h, vector<cell>(w, dead));
    for (int i = 0; i < strvec.size(); i++)
        for (int j = 0; j < strvec[i].length(); j++)
            if (strvec[i][j] == '#') init[i][j] = alive;
    return init;
}

int countNeighbors(board b, int row, int col){
    int n = 0;
    int h = b.size();
    int w = b[0].size();
    if (b[row][col] == alive) n -= 1;
    for (int i = -1; i <= 1; i++) for (int j = -1; j <= 1; j++)
        if (b[(row+i+h) % h][(col+j+w) % w] == alive) n += 1;
    return n;
}

board nextState(board oldboard){
    board newboard = oldboard;
    for (int i = 0; i < oldboard.size(); i ++)
        for (int j = 0; j < oldboard[i].size(); j++) {
            int n = countNeighbors(oldboard, i, j);
            if ((oldboard[i][j] == alive) and ((n < 2) or (n > 3)))
                newboard[i][j] = dead;
            else if ((oldboard[i][j] == dead) and (n == 3))
                newboard[i][j] = alive;
        }
    return newboard;
}

int main(){
    string header;
    string buff;
    vector<string> initstr;

    ifstream input("input.txt");
        getline(input, header);
        while (getline(input, buff)) initstr.push_back(buff);
    input.close();

    stringstream ss(header);
    getline(ss,buff,' '); const int height = stoi(buff);
    getline(ss,buff,' '); const int width  = stoi(buff);

    board world = initBoard(initstr, height, width);
    showBoard(world, '#', '.');
    while (true) {
        cout << "\033[" << height << 'A';
        world = nextState(world);
        showBoard(world, '#', '.');
        sleep(250);
    }
    return 0;
}
