import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game.dart';
//import 'package:hello/pages/game/game.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  //Game? _game;
  late Game _game; //initialize ทีหลัง
  final _controller = TextEditingController();
  String? data;
  String? _feedback;
  var guessed = [];

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override //Ctrl+O or Code=>Override method
  void initState() {
    //Flutter auto call once time at first time
    //ส่วนใหญ่จะ initialize state variable in this initState method
    super.initState();
    _game = Game();
  }

  @override
  void dispose() {
    //Clear it when finish used
    _controller.dispose();
    super.dispose();
  }

  /*var guess = Game();
  var controller = TextEditingController();
  var checkValue = 2;*/
  @override
  Widget build(BuildContext context) {
    //Render all the time (initField)
    return Scaffold(
      body: Container(
          color: Colors.yellow.shade100,
          /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo_number.png"),
            fit: BoxFit.fill,
          ),
        ),*/
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(),
                  _buildMainContent(), //TextFormField(),
                  _buildInputPanel(),
                ],
              ),
            ),
          )),
    );
  }

  //Right Click -> Refactor -> Extract Method เพื่อที่จะสร้าง method ของ Widget

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo_number.png",
          width: 240.0, //160 = 1 inch
        ),
        Text(
          'GUESS THE NUMBER',
          style: GoogleFonts.mcLaren(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return data == null
        ? Column(
            children: [
              Text(
                "I'm thinking of a number between 1 to 100.\n",
                style: TextStyle(fontSize: 30.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Can you guess it? ",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Icon(
                    Icons.favorite,
                    size: 40.0,
                    color: Colors.pink,
                  ),
                ],
              ),
            ],
          )
        : Column(
            children: [
              Text(
                data!,
                style: TextStyle(fontSize: 40.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_feedback == "NICE !")
                    Icon(
                      Icons.done,
                      size: 50.0,
                      color: Colors.green[400],
                    )
                  else
                    Icon(
                      Icons.close,
                      size: 50.0,
                      color: Colors.red[400],
                    ),
                  Text(
                    _feedback!,
                    style: TextStyle(fontSize: 40.0),
                  ),
                ],
              ),
              //reset
              if (_feedback == "NICE !")
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _feedback = null;
                        _game = new Game();
                        data = null;
                        guessed = [];
                      });
                    },
                    child: Text("NEW GAME"))
            ],
          );
  }

  Widget _buildInputPanel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: TextField(
          controller: _controller,
          enabled: (_feedback != null && _feedback == "NICE !")?false:true,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: Colors.yellow,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.0),
            isDense: true,
            // กำหนดลักษณะเส้น border ของ TextField ในสถานะปกติ
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange.withOpacity(0.5),
              ),
            ),
            // กำหนดลักษณะเส้น border ของ TextField เมื่อได้รับโฟกัส
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            hintText: 'Enter the number here',
            hintStyle: TextStyle(
              color: Colors.green[200],
              fontSize: 16.0,
            ),
          ),
        )),
        TextButton(
          onPressed: (_feedback != null && _feedback == "NICE !")?null: () {
            setState(() {
              data = _controller.text;
              int? guess = int.tryParse(data!);
              if (guess != null) {
                guessed.add(guess);
                var result = _game.doGuess(guess);
                _controller.clear();
                if (result == 0) {
                  //true
                  _feedback = 'NICE !';
                  _showMaterialDialog(
                      "YO YO นักศึกษา",
                      "The answer is $guess\nYou have made ${_game.totalGuesses} guesses.\n\n"
                          "${guessed}");
                } else if (result == 1) {
                  //too much
                  _feedback = 'Too High';
                } else {
                  //too low
                  _feedback = 'Too Low';
                }
              }
            });
          },
          child: Text("GUESS"),
        ),
      ],
    );
  }
}
