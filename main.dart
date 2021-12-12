import 'dart:core';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title = 'Tic-Tac-Toe';

  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
/*GameStatus:
  0 - the game is on
  1 - cross winner
  2 - zero winner
  3 - draw*/
  int _gameStatus = 0;

  //move counter
  int _counter = 0;

  //creating game's mesh
  var _mesh = List.generate(
      3,
      (index) => List.generate(
            3,
            (index) => 0,
            growable: false,
          ),
      growable: false);

  @override
  Widget build(BuildContext context) {
    List<GameCard> getCardList() {
      List<GameCard> cardList = [];

      for (int row = 0; row < 3; row++) {
        for (int col = 0; col < 3; col++) {
          cardList.add(GameCard(
            row: row,
            col: col,
            mesh: _mesh,
            onPressed: changeCard,
          ));
        }
      }
      return cardList;
    }

    final List<GameCard> cardList = getCardList();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: GridView.count(
              padding: EdgeInsets.all(5),
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              children: cardList,
            ),
          ),
          // Flexible(
          //   flex: 1,
          //   child: Center(
          //     child: Text(
          //       '$_mesh counter: $_counter',
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 30,
          ),
          Center(child: getGameStatus()),
          SizedBox(
            height: 30,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Restart",
        child: Icon(
          Icons.refresh,
        ),
        onPressed: restartGame,
      ),
    );
  }

  dynamic changeCard(int row, int col) {
    setState(() {
      if (_mesh[row][col] == 0 && _gameStatus == 0) {
        if (_counter % 2 == 0) {
          _mesh[row][col] = 1;
          _counter++;
          checkingWinner(row, col);
        } else {
          _mesh[row][col] = 2;
          _counter++;
          checkingWinner(row, col);
        }
      }
    });
  }

  dynamic checkingWinner(int row, int col) {
    //5 is the minimum number of moves to win
    if (_counter >= 5) {
      checkingRow(row);
      checkingCol(col);
      checkingLeftDiagonal();
      checkingRightDiagonal();
      checkingForDraw();
    }
  }

  void checkingRow(int row) {
    if (_mesh[row][0] == _mesh[row][1] && _mesh[row][0] == _mesh[row][2]) {
      _counter % 2 != 0 ? _gameStatus = 1 : _gameStatus = 2;
    }
  }

  void checkingCol(int col) {
    if (_mesh[0][col] == _mesh[1][col] && _mesh[0][col] == _mesh[2][col]) {
      _counter % 2 != 0 ? _gameStatus = 1 : _gameStatus = 2;
    }
  }

  void checkingLeftDiagonal() {
    if (_mesh[0][0] == _mesh[1][1] &&
        _mesh[1][1] == _mesh[2][2] &&
        _mesh[2][2] != 0) {
      _counter % 2 != 0 ? _gameStatus = 1 : _gameStatus = 2;
    }
  }

  void checkingRightDiagonal() {
    if (_mesh[2][0] == _mesh[1][1] &&
        _mesh[1][1] == _mesh[0][2] &&
        _mesh[0][2] != 0) {
      _counter % 2 != 0 ? _gameStatus = 1 : _gameStatus = 2;
    }
  }

  void checkingForDraw() {
    if (_counter == 9) {
      _gameStatus = 3;
    }
  }

  Text getGameStatus() {
    const Text crossWinner = Text(
      'Cross winner!!!',
      style: TextStyle(
        fontSize: 20,
      ),
    );
    const Text zeroWinner = Text(
      'Zero winner!!!',
      style: TextStyle(
        fontSize: 20,
      ),
    );
    const Text draw = Text(
      'Draw!',
      style: TextStyle(
        fontSize: 20,
      ),
    );
    const Text info = Text(
      'Tap on card to change!',
      style: TextStyle(
        fontSize: 20,
      ),
    );

    switch (_gameStatus) {
      case 1:
        return crossWinner;
      case 2:
        return zeroWinner;
      case 3:
        return draw;
      default:
        return info;
    }
  }

  void restartGame() {
    setState(() {
      _counter = 0;
      _mesh = List.generate(3, (index) => List.generate(3, (index) => 0));
      _gameStatus = 0;
    });
  }
}

class GameCard extends StatefulWidget {
  final int row;
  final int col;
  final mesh;
  final dynamic Function(int x, int y) onPressed;

  const GameCard({
    Key? key,
    required this.row,
    required this.col,
    required this.mesh,
    required this.onPressed,
  });

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  final Icon defaultCard = Icon(
    Icons.brightness_1,
    size: 0,
    color: Colors.white54,
  );
  final Icon crossIcon = Icon(
    Icons.clear_outlined,
    size: 100,
  );
  final Icon zeroIcon = Icon(
    Icons.circle_outlined,
    size: 100,
  );

  Icon getIcon() {
    if (widget.mesh[widget.row][widget.col] != 0) {
      return widget.mesh[widget.row][widget.col] == 1 ? crossIcon : zeroIcon;
    } else {
      return defaultCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(
          widget.row,
          widget.col,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: Center(
          child: getIcon(),
        ),
      ),
    );
  }
}

class GameLogic {}
