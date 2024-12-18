import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:reelzaty/features/model/reels/reel.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'reel_item_widgets.dart';

class ReelItem extends StatefulWidget {
  final int index;
  final Reel reel;
  const ReelItem({
    super.key,
    required this.index,
    required this.reel,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  VideoPlayerController? controller;
  final ValueNotifier<double?> seekValue = ValueNotifier(null);
  ValueNotifier<bool> _longPress = ValueNotifier(false),
      _paused = ValueNotifier(false);
  bool visible = true;
  // _lostFocus = false;
  final StreamController<double> positionController =
      StreamController<double>.broadcast();

  final String _kReelCacheKey = "reelsCacheKey";
  late final CacheManager _kCacheManager = CacheManager(
    Config(
      _kReelCacheKey,
      stalePeriod: const Duration(days: 7), // Maximum cache duration
      maxNrOfCacheObjects: 100, // maximum reels to cache
      repo: JsonCacheInfoRepository(databaseName: _kReelCacheKey),
      fileService: HttpFileService(),
    ),
  );
  @override
  void initState() {
    _initialize();
    super.initState();
  }

  Future<void> _initialize() async {
    // if (!mounted) return;
    final FileInfo info =
        (await _kCacheManager.getFileFromCache(widget.reel.url)) ??
            await _kCacheManager.downloadFile(
              widget.reel.url,
            );
    //"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"
    // if (!mounted) return;
    controller = VideoPlayerController.file(
      info.file,
    );
    controller?.initialize().then((value) {
      // if (!mounted) return;

      controller?.setLooping(true);
      controller?.addListener(_videoListener);
      if (!controller!.value.isPlaying) controller?.play();
      setState(() {});
      // setState(() {});
    });
  }

  void _videoListener() {
    // if (mounted) return;
    positionController.sink.add(controller!.value.position.inSeconds /
        controller!.value.duration.inSeconds);
  }

  @override
  void dispose() {
    controller
      ?..seekTo(Duration.zero)
      ..pause()
      ..removeListener(_videoListener)
      ..dispose();
    log('disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        GestureDetector(
          onLongPressEnd: (details) {
            if (controller == null) return;
            if (_longPress.value) {
              _longPress.value = false;
              if (!controller!.value.isPlaying) {
                controller?.play().then((value) => _paused.value = false);
              }
            }
          },
          onLongPress: () {
            if (controller == null) return;
            if (!_longPress.value) {
              setState(() {
                _longPress.value = true;
                if (controller!.value.isPlaying) {
                  controller?.pause().then((value) => _paused.value = true);
                }
              });
            }
          },
          onTap: () {
            if (controller == null) return;
            log(controller!.value.errorDescription.toString());
            if (!controller!.value.isPlaying) {
              controller?.play().then((value) => setState(() {
                    _paused.value = false;
                  }));
              return;
            }
            controller?.pause().then((value) => setState(() {
                  _paused.value = true;
                }));
          },
          child: VisibilityDetector(
            key: ValueKey(widget.index),
            onVisibilityChanged: (info) {
              if (controller == null) return;
              final double percentage = info.visibleFraction * 100;
              if (percentage == 100) {
                visible = true;
              }
              if (percentage == 0) {
                visible = false;
              }
              // // visible = percentage > 0;
              // if (!visible) {
              //   _paused = false;
              //   if (!mounted) return;
              //   setState(() {});
              // }
              // // _paused = false;
              // if (_dragging || _paused || _longPress) return;

              log("${widget.index} percentage: $visible");

              if (visible) {
                while (!controller!.value.isPlaying) {
                  if (_paused.value) return;
                  controller?.play().then((_) {
                    _paused.value = false;
                  });
                }
                //   // _lostFocus = false;

                //   // setState(() {});
              } else if (controller!.value.isInitialized) {
                controller?.pause().then((value) => _paused.value = false);
                if (controller!.value.position != Duration.zero) {
                  controller?.seekTo(Duration.zero);
                }
              }
            },
            child: Container(
              color: Colors.black,
              // height: double.infinity,
              child: controller != null &&
                      controller!.value.isInitialized &&
                      controller!.value.errorDescription == null
                  ? Center(
                      child: AspectRatio(
                        aspectRatio: size.width /
                            size.height, //controller!.value.aspectRatio,
                        child: VideoPlayer(
                          controller!,
                        ),
                      ),
                    )
                  : controller == null ||
                          (controller != null &&
                              controller!.value.errorDescription == null)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text(
                            controller!.value.errorDescription.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
            ),
          ),
        ),
        if (controller == null ||
            (controller != null &&
                controller!.value.isInitialized &&
                controller!.value.errorDescription == null))
          ValueListenableBuilder(
              valueListenable: _longPress,
              builder: (context, value, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: value ? 0 : 1,
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
                                ReelInfoTile(
                                    index: widget.index, reel: widget.reel),
                                SoundTile(
                                  reel: widget.reel,
                                ),
                              ],
                            ),
                          ),
                          IconBar(
                            reel: widget.reel,
                          ),
                        ],
                      ),

                      // const SizedBox(height: 16),
                      StreamBuilder<double>(
                          stream: positionController.stream,
                          builder: (context, snapshot) {
                            return ValueListenableBuilder(
                                valueListenable: seekValue,
                                builder: (context, dragValue, _) {
                                  return ValueListenableBuilder(
                                      valueListenable: _paused,
                                      builder: (context, paused, _) {
                                        return VideoSlider(
                                          paused: paused,
                                          loading: controller == null ||
                                              !controller!
                                                  .value.isInitialized ||
                                              controller!.value.isBuffering,
                                          value:
                                              dragValue ?? snapshot.data ?? 0,
                                          onChanged: (value) {
                                            if (controller == null) return;
                                            if (!controller!
                                                .value.isInitialized) return;
                                            if (controller!.value.isPlaying) {
                                              return;
                                            }

                                            seekValue.value = value;
                                          },
                                          onChangeStart: (value) {
                                            // controller?.pause().then((_) => setState(() {
                                            //       _dragging = true;
                                            //     }));
                                            controller?.pause();
                                          },
                                          onChangeEnd: (value) {
                                            if (controller == null ||
                                                !controller!.value
                                                    .isInitialized) return;

                                            controller
                                                ?.seekTo(
                                              Duration(
                                                seconds: (value *
                                                        controller!.value
                                                            .duration.inSeconds)
                                                    .toInt(),
                                              ),
                                            )
                                                .then((_) {
                                              // controller?.play().then((_) => setState(() {
                                              //       seekValue = null;
                                              //       _dragging = false;
                                              //       _paused = false;
                                              //       // _lostFocus = false;
                                              //     }));
                                              controller?.play().then((_) {
                                                seekValue.value = null;
                                                _paused.value = false;
                                              });
                                            });
                                          },
                                        );
                                      });
                                });
                          }),
                    ],
                  ),
                );
              }),
        if (controller != null &&
            controller!.value.isInitialized &&
            !controller!.value.isBuffering &&
            controller!.value.errorDescription == null)
          ValueListenableBuilder(
              valueListenable: _paused,
              builder: (context, paused, _) {
                if (!paused) return const SizedBox.shrink();
                return ValueListenableBuilder(
                    valueListenable: _longPress,
                    builder: (context, longPress, _) {
                      return IgnorePointer(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: longPress ? 0 : 1,
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 100,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    });
              })
      ],
    );
  }
}
