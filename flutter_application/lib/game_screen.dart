import 'package:flutter/material.dart';
import 'package:flutter_application/utils.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hangman",
          style: restroStyle(20, Colors.white, FontWeight.bold),
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
                  "12 Points",
                  style: restroStyle(15, Colors.black, FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Image(
                image: AssetImage("images/hangman0.png"),
                width: 150,
                height: 150,
                color: Colors.white,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                "5 lifes left",
                style: restroStyle(15, Colors.grey, FontWeight.bold),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
