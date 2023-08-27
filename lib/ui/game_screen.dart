import 'dart:async';

import 'package:clicker/Model/game.dart';
import 'package:clicker/Model/games_manager.dart';
import 'package:clicker/ui/hall_of_fame_screen.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class GameScreen extends StatelessWidget {
  final gamesManager = GamesManager();

  GameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Clicker"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: gamesManager.loadGamesListFromLocalDatas(),
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.hasError) {
              return _GameScreenContent(
                gamesManager: gamesManager,
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class _GameScreenContent extends StatefulWidget {
  final GamesManager gamesManager;
  const _GameScreenContent({required this.gamesManager});
  @override
  State<_GameScreenContent> createState() =>
      __GameScreenContentState(gamesManager);
}

class __GameScreenContentState extends State<_GameScreenContent> {
  final GamesManager gamesManager;
  var _currentPlayerName = "";
  var _currentNameFieldController = TextEditingController();

  final List<Game> _resultList = [];

  __GameScreenContentState(this.gamesManager);

  _buttonClickHide() {
    setState(() {
      gamesManager.startNewGame(username: _currentPlayerName);
      Timer(const Duration(seconds: GamesManager.gameDuration), _stopGame);
    });
  }

  _stopGame() {
    setState(() {
      gamesManager.finishCurrentGame();
    });
  }

  _ButtonClickPlus() {
    setState(() {
      gamesManager.currentGame?.userScored();
    });
  }

  _currentUserChanged(String newUserName) {
    setState(() {
      _currentPlayerName = newUserName;
    });
  }

  @override
  void dispose() {
    _currentNameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bestGame = gamesManager.bestGame;
    final currentGame = gamesManager.currentGame;
    final isInProgress = gamesManager.isGameInProgress;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (isInProgress == false)
        TextField(
          autocorrect: false,
          onChanged: _currentUserChanged,
          controller: _currentNameFieldController,
        ),
      if (bestGame != null)
        Text(S.current.point_record(bestGame.playerName, bestGame.score)),
      if (currentGame != null)
        Text(S.current.count_click(currentGame.score))
      else
        Text(S.of(context).before_text_game),
      if (isInProgress)
        IconButton(
            onPressed: _ButtonClickPlus, icon: const Icon(Icons.plus_one))
      else
        ElevatedButton(
            onPressed: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HallOfFameScreen(
                          gamelist: gamesManager.bestGameLis))),
                },
            child: Text("Hall of fame")),
      const Spacer(),
      if (isInProgress == false)
        ElevatedButton(
            onPressed: _buttonClickHide,
            child: Text(S.of(context).game_start_button)),
    ]);
  }
}
