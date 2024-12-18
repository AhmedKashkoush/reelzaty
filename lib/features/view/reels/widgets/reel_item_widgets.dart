part of 'reel_item.dart';

class VideoSlider extends StatelessWidget {
  final void Function(double)? onChanged, onChangeStart, onChangeEnd;
  final double value;
  final bool loading, paused;
  const VideoSlider({
    super.key,
    this.onChanged,
    required this.value,
    this.onChangeStart,
    this.onChangeEnd,
    required this.loading,
    required this.paused,
  });

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            margin: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 4.0),
            height: 6,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: const LinearProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.white54,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme(
              data: ThemeData(
                sliderTheme: SliderThemeData(
                  thumbShape: paused
                      ? const RoundSliderThumbShape(enabledThumbRadius: 6)
                      : const RoundSliderThumbShape(
                          enabledThumbRadius: 3,
                          elevation: 0,
                        ),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white54,
                  thumbColor: Colors.white,
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
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
              ),
            ),
          );
  }
}

class ReelInfoTile extends StatelessWidget {
  const ReelInfoTile({
    super.key,
    required this.index,
    required this.reel,
  });

  final int index;
  final Reel reel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        reel.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        reel.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}

class SoundTile extends StatelessWidget {
  final Reel reel;
  const SoundTile({
    super.key,
    required this.reel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 32,
      title: TextScroll(
        'Music name' * 4,
        mode: TextScrollMode.endless,
        velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
        delayBefore: const Duration(milliseconds: 500),
        pauseBetween: const Duration(milliseconds: 500),
        fadedBorder: true,
        fadeBorderVisibility: FadeBorderVisibility.auto,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Container(
        width: 38,
        height: 38,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const FittedBox(
          child: Icon(
            HugeIcons.strokeRoundedMusicNote03,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class IconBar extends StatelessWidget {
  final Reel reel;
  const IconBar({
    super.key,
    required this.reel,
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
                child: Icon(HugeIcons.strokeRoundedUser, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              HugeIcons.strokeRoundedFavourite,
              color: Colors.white,
              size: 32,
            ),
          ),
          Text(
            reel.likes > 0 && reel.likesShown ? '${reel.likes}' : 'Likes',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: reel.commentsDisabled ? null : () {},
            icon: Icon(
              HugeIcons.strokeRoundedComment01,
              color: reel.commentsDisabled ? Colors.grey : Colors.white,
              size: 32,
            ),
          ),
          Text(
            reel.commentsDisabled
                ? 'Disabled'
                : reel.comments > 0 && reel.commentsShown
                    ? '${reel.comments}'
                    : 'Comments',
            style: TextStyle(
                color: reel.commentsDisabled ? Colors.grey : Colors.white),
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
          Text(
            reel.shares > 0 && reel.sharesShown ? '${reel.shares}' : 'Shares',
            style: const TextStyle(color: Colors.white),
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
          const Text(
            'Save',
            style: TextStyle(color: Colors.white),
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
