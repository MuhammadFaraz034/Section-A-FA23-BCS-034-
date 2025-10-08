import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice App',
      debugShowCheckedModeBanner: false,
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  int diceNumber = 1;
  final TextEditingController _guessController = TextEditingController();
  String message = "";

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;

      if (_guessController.text.isNotEmpty) {
        int? guess = int.tryParse(_guessController.text);
        if (guess != null && guess == diceNumber) {
          message = "🎉 Correct Guess! It's $diceNumber";
        } else {
          message = "❌ Wrong Guess! It's $diceNumber";
        }
      } else {
        message = "You rolled a $diceNumber";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎲 Dice Roller"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                diceNumber = 1;
                message = "";
                _guessController.clear();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _guessController,
              decoration: InputDecoration(
                labelText: "Enter your guess (1-6)",
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: rollDice,
              child: Image.asset("assets/images/$diceNumber.png", height: 150),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: rollDice,
              icon: Icon(Icons.casino),
              label: Text("Roll Dice"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
