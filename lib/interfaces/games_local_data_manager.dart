// ignore_for_file: empty_constructor_bodies

import 'dart:async';
import 'package:clicker/Model/game.dart';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
part 'games_local_data_manager.g.dart'; // the generated code will be there

class GamesLocalDataManager {
  Future<GameDao> get _gameDao async {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    return database.gameDao;
  }

  Future<void> addNewGame(Game game) async {
    final gameDao = await _gameDao;
    gameDao.insertGame(FLGame.fromGame(game));
  }

  Future<List<Game>> getGamesList() async {
    final gameDao = await _gameDao;
    final flGameList = await gameDao.findAllGame();
    return flGameList.map((flgame) => flgame.game).toList();
  }
}

@dao
abstract class GameDao {
  @Query('SELECT * FROM FLGame')
  Future<List<FLGame>> findAllGame();

  @insert
  Future<void> insertGame(FLGame game);
}

@entity
class FLGame {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String playerName;
  final int score;

  FLGame(this.id, this.playerName, this.score);
  FLGame.fromGame(Game game)
      : playerName = game.playerName,
        score = game.score;

  Game get game => Game(playerName: playerName, score: score);
}

@Database(version: 1, entities: [FLGame])
abstract class AppDatabase extends FloorDatabase {
  GameDao get gameDao;
}
