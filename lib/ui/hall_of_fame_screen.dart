import 'package:flutter/material.dart';

import '../Model/game.dart';
import '../generated/l10n.dart';

class HallOfFameScreen extends StatelessWidget {
  final List<Game> _gamelist;

  const HallOfFameScreen({Key? key, required gamelist})
      : _gamelist = gamelist,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hall of fame"),
      ),
      body: ListView.builder(
          itemCount: _gamelist.length, itemBuilder: makeForRowResult),
    );
  }

  Widget? makeForRowResult(BuildContext context, int index) {
    final result = _gamelist[index];
    return Row(
      children: [
        Text(
          result.playerName,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 24),
        ),
        const Icon(Icons.military_tech),
        Text(S.of(context).result_score_points(result.score)),
      ],
    );
  }
}
