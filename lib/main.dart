import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.orange, // Custom button color
            textStyle: TextStyle(fontSize: 18.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  bool xTurn = true;
  bool gameOver = false;
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              gameOver
                  ? (winner.isNotEmpty ? 'Winner: $winner' : 'It\'s a draw!')
                  : (xTurn ? 'Player X\'s Turn' : 'Player O\'s Turn'),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _buildRow(i)),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: gameOver
                  ? () {
                      resetGame();
                    }
                  : null,
              child: Text('Reset Game'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(int rowIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (colIndex) => _buildButton(rowIndex, colIndex)),
    );
  }

  Widget _buildButton(int rowIndex, int colIndex) {
    return GestureDetector(
      onTap: () {
        if (!gameOver && board[rowIndex][colIndex].isEmpty) {
          setState(() {
            board[rowIndex][colIndex] = xTurn ? 'X' : 'O';
            checkWinner();
            xTurn = !xTurn;
          });
        }
      },
      child: Container(
        width: 60.0,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: board[rowIndex][colIndex].isEmpty ? Colors.white : Colors.blue,
        ),
        child: Text(
          board[rowIndex][colIndex],
          style: TextStyle(fontSize: 30.0, color: Colors.black),
        ),
      ),
    );
  }

  void checkWinner() {
    // Check rows
    for (int i = 0; i < 3; i++) {
      if (board[i][0] == board[i][1] && board[i][0] == board[i][2] && board[i][0].isNotEmpty) {
        winner = board[i][0];
        gameOver = true;
        showWinnerCelebration();
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[0][i] == board[1][i] && board[0][i] == board[2][i] && board[0][i].isNotEmpty) {
        winner = board[0][i];
        gameOver = true;
        showWinnerCelebration();
        return;
      }
    }

    // Check diagonals
    if (board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0].isNotEmpty) {
      winner = board[0][0];
      gameOver = true;
      showWinnerCelebration();
      return;
    }
    if (board[0][2] == board[1][1] && board[0][2] == board[2][0] && board[0][2].isNotEmpty) {
      winner = board[0][2];
      gameOver = true;
      showWinnerCelebration();
      return;
    }

    // Check for draw
    bool allFilled = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          allFilled = false;
          break;
        }
      }
    }
    if (allFilled) {
      gameOver = true;
    }
  }

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      xTurn = true;
      gameOver = false;
      winner = '';
    });
  }

  void showWinnerCelebration() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('Player $winner wins!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
