import 'package:flutter/material.dart';
import 'treasure_hunt_map.dart';

class TreasureHuntScreen extends StatelessWidget {
  const TreasureHuntScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TreasureHuntMap(),
    );
  }
}
