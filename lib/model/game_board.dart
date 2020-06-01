import 'dart:math';

import 'package:fifteen_game/model/board_item.dart';

class GameBoard {

  List<List<BoardItem>> board;
  int rowCount;
  int columnCount;
  int moves;

  GameBoard(int rowCount, int columnCount) {
    int num = 1;
    this.moves = 0;
    this.rowCount = rowCount;
    this.columnCount = columnCount;
    this.board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardItem(num++);
      });
    });

    board[rowCount-1][columnCount-1].isEmpty = true;

    checkNears();
  }

  BoardItem getItem(int rowNumber, int columnNumber) {
    return board[rowNumber][columnNumber];
  }

  void swapItems(int rowNumber, int columnNumber) {
    if(board[rowNumber][columnNumber].isNearEmpty) {
      int row;
      int column;

      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          if (board[i][j].isEmpty) {
            row = i;
            column = j;
          }
        }
      }

      BoardItem item = BoardItem(0);
      item.swapItem(board[rowNumber][columnNumber]);
      board[rowNumber][columnNumber].swapItem(board[row][column]);
      board[row][column].swapItem(item);

      moves++;

      checkNears();
    }
  }

  void checkNears() {
    int row;
    int column;

    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        board[i][j].isNearEmpty = false;
        if (board[i][j].isEmpty) {
          row = i;
          column = j;
        }
      }
    }

    if (row > 0) board[row - 1][column].isNearEmpty = true;
    if (row < rowCount - 1) board[row + 1][column].isNearEmpty = true;
    if (column > 0) board[row][column - 1].isNearEmpty = true;
    if (column < columnCount - 1) board[row][column + 1].isNearEmpty = true;
  }

  void shuffleItems() {
    Random random = Random();

    for (int t = 0; t < 200; t++) {
      List<int> rows = [];
      List<int> columns = [];
      int num = 0;
      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          if (board[i][j].isNearEmpty) {
            rows.add(i);
            columns.add(j);
            num++;
          }
        }
      }
      int randomNumber = random.nextInt(num);
      swapItems(rows[randomNumber], columns[randomNumber]);
    }

    moves = 0;
  }

  bool checkWin() {
    if (moves > 0) {
      int num = 0;

      for (int i = 0; i < rowCount; i++) {
        for (int j = 0; j < columnCount; j++) {
          if (board[i][j].number == i * rowCount + j + 1) {
            num++;
          }
        }
      }

      if (num == rowCount * columnCount) {
        return true;
      }
      else
        return false;
    } else return false;
  }

}