import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application/utils.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String word = wordsList[Random().nextInt(wordsList.length)];
  List guessedChars = [];
  String userGuess = "";
  int points = 0;
  int status = 0;
  bool isWon = false;

  handleText() {
    String displayedWOrd = "";
    for (int i = 0; i < word.length; i++) {
      String char = word[i];

      if (guessedChars.contains(char)) {
        displayedWOrd += char;
      } else {
        displayedWOrd += "?";
      }
    }
    print("$displayedWOrd");

    setState(() {
      userGuess = displayedWOrd;
      isWon = displayedWOrd == word;
    });
  }

  handleKeyboard(String char) {
    if (word.contains(char)) {
      setState(() {
        guessedChars.add(char);
        points += 5;
      });
    } else if (status != 6) {
      setState(() {
        points -= 5;
        status++;
      });
    } else {
      print("You Lost");
    }
    handleText();
  }

  @override
  void initState() {
    // TODO: implement initState
    handleText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hangman",
          style: retroStyle(20, Colors.white, FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.volume_up_sharp,
                color: Colors.purpleAccent,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(color: Colors.blue),
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "$points Points",
                  style: retroStyle(15, Colors.black, FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("images/hangman$status.png"),
                width: 150,
                height: 150,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                "${6 - status} lives left ${userGuess == word ? " Won" : ""}",
                style: retroStyle(15, Colors.grey, FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                userGuess,
                style: retroStyle(35, Colors.white, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: alphabets
                    .map((char) => InkWell(
                          onTap: status != 6
                              ? () {
                                  print("pressed $char ");
                                  handleKeyboard(char);
                                }
                              : null,
                          child: Center(
                            child: Text(
                              char,
                              style:
                                  retroStyle(20, Colors.white, FontWeight.bold),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              isWon
                  ? Text(
                      "You Won",
                      style: retroStyle(20, Colors.white, FontWeight.bold),
                    )
                  : Container(),
              status == 6
                  ? Text(
                      "You Lost",
                      style: retroStyle(20, Colors.white, FontWeight.bold),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
