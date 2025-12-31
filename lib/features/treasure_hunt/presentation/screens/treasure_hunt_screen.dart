import 'package:flutter/material.dart';
import 'treasure_hunt_map.dart'; // Chung thư mục, gọi trực tiếp

class TreasureHuntScreen extends StatelessWidget {
  const TreasureHuntScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TreasureHuntMap(),
    );
  }
}