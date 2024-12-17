import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

part 'reel_item_widgets.dart';

class ReelItem extends StatelessWidget {
  const ReelItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const IconBar(),
            // const SizedBox(height: 8),
            const SoundTile(),
            // const SizedBox(height: 16),
            VideoSlider(
              value: 0.5,
              onChanged: (value) {},
            ),
            // const TextField(
            //   readOnly: true,
            //   enableInteractiveSelection: false,
            //   decoration: InputDecoration(
            //     hintText: 'Comment here...',
            //     hintStyle: TextStyle(
            //       color: Colors.white,
            //     ),
            //     isDense: true,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(24),
            //       ),
            //       borderSide: BorderSide(
            //         color: Colors.white,
            //       ),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(24),
            //       ),
            //       borderSide: BorderSide(
            //         color: Colors.white,
            //       ),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(24),
            //       ),
            //       borderSide: BorderSide(
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
