class Game implements Comparable<Game> {
  final String playerName;
  int _score;
  bool _isInprogress = false;

  int get score => _score;
  bool get isInProgress => _isInprogress;

  Game({required this.playerName, score = 0}) : _score = score;

  start() {
    _score = 0;
    _isInprogress = true;
  }

  finish() {
    _isInprogress = false;
  }

  userScored() {
    if (_isInprogress) {
      _score++;
    }
  }

  @override
  int compareTo(Game other) {
    return score.compareTo(other.score);
  }
}
