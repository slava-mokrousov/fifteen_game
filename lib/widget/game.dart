import 'package:fifteen_game/database/database.dart';
import 'package:fifteen_game/model/game_board.dart';
import 'package:fifteen_game/widget/leader_board.dart';
import 'package:flutter/material.dart';

class GameActivity extends StatefulWidget {
  @override
  _GameActivityState createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {
  int rowCount = 4;
  int columnCount = 4;

  GameBoard board;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Fifteen-game'),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onTap: () {
            _initializeGame();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => LeaderBoard())),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 50,
            child: Center(
              child: Text(
                'moves: ${board.moves}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnCount),
            itemBuilder: (context, position) {
              int rowNumber = (position / columnCount).floor();
              int columnNumber = (position % columnCount);

              return InkWell(
                onTap: () {
                  board.swapItems(rowNumber, columnNumber);
                  _handleWin();

                  setState(() {});
                },
                splashColor: Colors.grey,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                  alignment: Alignment.center,
                  child: board.getItem(rowNumber, columnNumber).isEmpty
                      ? Text('')
                      : Text(
                          board
                              .getItem(rowNumber, columnNumber)
                              .number
                              .toString(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                ),
              );
            },
            itemCount: rowCount * columnCount,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    board = GameBoard(rowCount, columnCount);
    board.shuffleItems();

    setState(() {});
  }

  void _handleWin() async {
    if (board.checkWin()) {
      await DBProvider.db.newRecord(board.moves);
      await DBProvider.db.deleteWorst();
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Congratulations'),
              content: Text('You win \nTotal moves: ${board.moves}'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    _initializeGame();
                    Navigator.pop(context);
                  },
                  child: Text('Play again'),
                )
              ],
            );
          });
    }
  }
}
