import 'package:go_router/go_router.dart';
import 'package:reelzaty/config/routes/routes.dart';
import 'package:reelzaty/features/view/reels/screens/reels_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        builder: (context, state) => const ReelsScreen(),
      ),
    ],
  );
}
