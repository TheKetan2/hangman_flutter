import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
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
  bool soundOn = true;

  final player = AudioPlayer();

//************** */

  playSound(String sound) async {
    if (soundOn) {
      await player.play(AssetSource(sound));
    }
  }

//************** */
  handleText() {
    String displayedWOrd = "";
    for (int i = 0; i < word.length; i++) {
      String char = word[i];

      if (guessedChars.contains(char)) {
        displayedWOrd += char;
        playSound("correct.mp3");
      } else {
        displayedWOrd += "?";
        playSound("wrong.mp3");
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

    if (isWon) {
      // showDialogue("You Won!");
      playSound("won.mp3");

      openDialogue("You Won!");
    }
    if (status == 6) {
      // showDialogue("You Lost!");
      playSound("lost.mp3");

      openDialogue("You Lost!");
    }
  }

  openDialogue(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: const BoxDecoration(
                color: Colors.purpleAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: retroStyle(
                      25,
                      Colors.white,
                      FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Your points: $points",
                    style: retroStyle(
                      25,
                      Colors.white,
                      FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      onPressed: () {
                        playSound("restart.mp3");

                        Navigator.pop(context);

                        setState(() {
                          points = 0;
                          status = 0;
                          word = wordsList[Random().nextInt(wordsList.length)];
                          guessedChars.clear();
                          userGuess = handleText();
                          isWon = false;
                        });
                      },
                      child: Center(
                        child: Text(
                          "Restart",
                          style: retroStyle(
                            20,
                            Colors.white,
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
              onPressed: () {
                setState(() {
                  soundOn = !soundOn;
                });
              },
              icon: Icon(
                soundOn ? Icons.volume_up_sharp : Icons.volume_mute,
                color: soundOn ? Colors.green : Colors.redAccent,
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
                decoration: const BoxDecoration(color: Colors.blue),
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  "$points Points",
                  style: retroStyle(15, Colors.black, FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("images/hangman$status.png"),
                width: 150,
                height: 150,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                "${6 - status} lives left ${userGuess == word ? " Won" : ""}",
                style: retroStyle(15, Colors.grey, FontWeight.bold),
              ),
              const SizedBox(
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
