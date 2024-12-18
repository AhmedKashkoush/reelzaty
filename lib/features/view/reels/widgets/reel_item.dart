import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'reel_item_widgets.dart';

class ReelItem extends StatefulWidget {
  final int index;
  const ReelItem({super.key, required this.index});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late final VideoPlayerController controller;
  double? seekValue;
  bool _longPress = false, _paused = false, _dragging = false, visible = true;
  // _lostFocus = false;
  final StreamController<double> positionController =
      StreamController<double>.broadcast();
  @override
  void initState() {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"),
    );
    controller.initialize().then((value) {
      setState(() {});
      // setState(() {
      //   controller.play().then((value) => setState(() {}));
      // });

      controller.setLooping(true);
      controller.addListener(_videoListener);
    });
    super.initState();
  }

  void _videoListener() {
    // if (mounted) return;
    positionController.sink.add(controller.value.position.inSeconds /
        controller.value.duration.inSeconds);
  }

  @override
  void dispose() {
    controller
      ..removeListener(_videoListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        GestureDetector(
          onLongPressEnd: (details) {
            if (_longPress) {
              setState(() {
                _longPress = false;
                if (!controller.value.isPlaying) {
                  controller.play().then((value) => setState(() {
                        _paused = false;
                      }));
                }
              });
            }
          },
          onLongPress: () {
            if (!_longPress) {
              setState(() {
                _longPress = true;
                if (controller.value.isPlaying) {
                  controller.pause().then((value) => setState(() {
                        _paused = true;
                      }));
                }
              });
            }
          },
          onTap: () {
            if (!controller.value.isPlaying) {
              controller.play().then((value) => setState(() {
                    _paused = false;
                  }));
              return;
            }
            controller.pause().then((value) => setState(() {
                  _paused = true;
                }));
          },
          child: VisibilityDetector(
            key: ValueKey(widget.index),
            onVisibilityChanged: (info) {
              final double percentage = info.visibleFraction * 100;
              visible = percentage > 50;
              if (!visible) {
                _paused = false;
                if (!mounted) return;
                setState(() {});
              }
              // _paused = false;
              if (_dragging || _paused || _longPress) return;

              log("${widget.index} percentage: $visible");

              if (visible) {
                if (!controller.value.isPlaying) controller.play();
                // _lostFocus = false;

                // setState(() {});
              } else if (controller.value.isInitialized) {
                controller.pause();
                if (controller.value.position != Duration.zero) {
                  controller.seekTo(Duration.zero);
                }
              }
            },
            child: Container(
              color: Colors.black,
              // height: double.infinity,
              child: !controller.value.isInitialized
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(
                          controller,
                        ),
                      ),
                    ),
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _longPress ? 0 : 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ReelInfoTile(index: widget.index),
                        const SoundTile(),
                      ],
                    ),
                  ),
                  const IconBar(),
                ],
              ),

              // const SizedBox(height: 16),
              StreamBuilder<double>(
                  stream: positionController.stream,
                  builder: (context, snapshot) {
                    return VideoSlider(
                      paused: _paused,
                      loading: !controller.value.isInitialized ||
                          controller.value.isBuffering,
                      value: seekValue ?? snapshot.data ?? 0,
                      onChanged: (value) {
                        log('message');
                        if (!controller.value.isInitialized) return;
                        if (controller.value.isPlaying) return;
                        setState(() {
                          seekValue = value;
                        });
                      },
                      onChangeStart: (value) {
                        controller.pause().then((_) => setState(() {
                              _dragging = true;
                            }));
                      },
                      onChangeEnd: (value) {
                        if (!controller.value.isInitialized) return;

                        controller
                            .seekTo(
                          Duration(
                            seconds:
                                (value * controller.value.duration.inSeconds)
                                    .toInt(),
                          ),
                        )
                            .then((_) {
                          controller.play().then((_) => setState(() {
                                seekValue = null;
                                _dragging = false;
                                _paused = false;
                                // _lostFocus = false;
                              }));
                        });
                      },
                    );
                  }),
            ],
          ),
        ),
        if (_paused &&
            controller.value.isInitialized &&
            !controller.value.isBuffering)
          IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _longPress ? 0 : 1,
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
