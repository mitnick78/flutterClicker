import 'game.dart';

class GamesManager {
  static const gameDuration = 10;
  Game? _currentGame;
  final List<Game> _previousGame = [];

  Game? get currentGame => _currentGame;
  Game? get bestGame {
    Game? topGame;
    for (var game in _previousGame) {
      if (topGame == null || topGame.score < game.score) {
        topGame = game;
      }
    }
    return topGame;
  }

  List<Game> get bestGameLis {
    final sortedList = List<Game>.from(_previousGame);
    sortedList.sort((game1, game2) => game2.compareTo(game1));
    return sortedList;
  }

  bool get isGameInProgress {
    final game = _currentGame;
    return game != null && game.isInProgress;
  }

  startNewGame({required String username}) {
    final newGame = Game(playerName: username);
    newGame.start();
    _currentGame = newGame;
  }

  finishCurrentGame() {
    final game = _currentGame;
    if (game != null) {
      game.finish();
      _previousGame.add(game);
    }
  }
}
