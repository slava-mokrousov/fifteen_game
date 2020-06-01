import 'package:fifteen_game/database/database.dart';
import 'package:fifteen_game/database/records.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Leaderboard'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete all records'),
                      content: Text('Are you sure?'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text('no'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await DBProvider.db.deleteAll();
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: Text('yes'),
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      //body: Container(color: Colors.red,),
      body: FutureBuilder<List<Record>>(
          future: DBProvider.db.getAllRecords(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Place",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Moves",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Record num = snapshot.data[index];
                          int place = index + 1;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                place.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(num.getMoves().toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          );
                        }),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Leaderboard is empty'),
              );
            }
          }),
    );
  }
}
