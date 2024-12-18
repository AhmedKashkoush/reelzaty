import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reelzaty/features/model/reels/reel.dart';
import 'package:reelzaty/features/view/reels/widgets/reel_profile_item.dart';
import 'package:reelzaty/features/view/reels/widgets/reel_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ValueNotifier<int> _index = ValueNotifier(0);
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);
  final PageController _reelsController =
      PageController(initialPage: 0, keepPage: true);
  bool _canPop = true;
  final List<String> _reels = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://cdn.pixabay.com/video/2022/02/08/107142-675298847_large.mp4",
    "https://cdn.pixabay.com/video/2017/04/04/8576-211573992_tiny.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  ];
  late final List<Reel> reels = _reels
      .map(
        (e) => Reel(
          id: '${_reels.indexOf(e)}',
          title: 'Reel ${_reels.indexOf(e) + 1}',
          description: 'Description ${_reels.indexOf(e) + 1}',
          views: 100,
          likes: 100,
          comments: 100,
          shares: 100,
          viewsShown: true,
          likesShown: true,
          commentsShown: true,
          sharesShown: true,
          commentsDisabled: _reels.indexOf(e) % 2 == 0,
          url: e,
        ),
      )
      .toList();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        log(const PageStorageKey<String>('reels').value);
        if (_canPop) return;
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: PageView(
        key: const PageStorageKey<String>('reels-screen'),
        controller: _pageController,
        physics: const CustomPageViewScrollPhysics(),
        onPageChanged: (value) => setState(() {
          _canPop = value.ceil() == 0;
        }),
        children: [
          ReelsView(
              reelsController: _reelsController, reels: reels, index: _index),
          ValueListenableBuilder(
              valueListenable: _index,
              builder: (context, value, _) {
                return ReelProfileItem(
                  index: value,
                );
              }),
        ],
      ),
    );
  }
}

class ReelsView extends StatefulWidget {
  const ReelsView({
    super.key,
    required PageController reelsController,
    required this.reels,
    required ValueNotifier<int> index,
  })  : _reelsController = reelsController,
        _index = index;

  final PageController _reelsController;
  final List<Reel> reels;
  final ValueNotifier<int> _index;

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView>
    with AutomaticKeepAliveClientMixin {
  late List<Reel> reels = List.from(widget.reels);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Reelzaty',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator.adaptive(
        displacement: 100,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            reels.clear();
          });
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              reels.addAll(List.from(widget.reels)..shuffle());
            });
          });
        },
        child: PageView.builder(
          key: const PageStorageKey<String>('reels'),
          physics: const CustomPageViewScrollPhysics(),
          controller: widget._reelsController,
          allowImplicitScrolling: true,
          itemBuilder: (context, index) => ReelItem(
            reel: reels[index],
            index: index,
          ),
          itemCount: reels.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => widget._index.value = index,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 120,
        stiffness: 200,
        damping: 1,
      );
}
