part of 'reel_item.dart';

class VideoSlider extends StatelessWidget {
  final void Function(double)? onChanged;
  final double value;
  const VideoSlider({
    super.key,
    this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Theme(
        data: ThemeData(
          sliderTheme: SliderThemeData(
            thumbShape: SliderComponentShape.noThumb,
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white54,
            trackHeight: 4,
            trackShape: CustomTrackShape(),
            valueIndicatorShape: const DropSliderValueIndicatorShape(),
          ),
        ),
        child: Slider(
          min: 0,
          max: 1,
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class SoundTile extends StatelessWidget {
  const SoundTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Music name'),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          HugeIcons.strokeRoundedMusicNote03,
          color: Colors.white,
        ),
      ),
    );
  }
}

class IconBar extends StatelessWidget {
  const IconBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              HugeIcons.strokeRoundedThumbsUp,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              HugeIcons.strokeRoundedComment01,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              HugeIcons.strokeRoundedShare08,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              HugeIcons.strokeRoundedBookmark01,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
