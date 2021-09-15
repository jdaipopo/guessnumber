import 'dart:math';

class Game {
  final int _answer;
  int _totalGuesses = 0;

  Game() : _answer = Random().nextInt(100) + 1 {
    print('The Answer is : ');
}

/*int getTotalGuesses() {
    return _totalGuesses;
}*/

  int get totalGuesses {
    return _totalGuesses;
  }

  int doGuess(int num) {
    _totalGuesses++;
      if(num > _answer) {
        return 1;
      }
      else if(num < _answer) {
        return -1;
      }
      else
        return 0;
    }
}