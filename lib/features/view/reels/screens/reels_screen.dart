import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reelzaty/features/view/reels/widgets/reel_profile_item.dart';
import 'package:reelzaty/features/view/reels/widgets/reel_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ValueNotifier<int> _index = ValueNotifier(0);

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
    return PageView(
      physics: const CustomPageViewScrollPhysics(),
      children: [
        Scaffold(
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
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1));
            },
            child: PageView.builder(
              key: const PageStorageKey<String>('reels'),
              physics: const CustomPageViewScrollPhysics(),
              allowImplicitScrolling: true,
              itemBuilder: (context, index) => ReelItem(
                index: index,
              ),
              itemCount: 10,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) => _index.value = index,
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: _index,
            builder: (context, value, _) {
              return ReelProfileItem(
                index: value,
              );
            }),
      ],
    );
  }
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
