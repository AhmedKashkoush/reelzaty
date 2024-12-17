import 'package:flutter/material.dart';

class ReelProfileItem extends StatelessWidget {
  final int index;
  const ReelProfileItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Screen $index'),
      ),
    );
  }
}
