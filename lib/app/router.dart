import 'package:call_court/ui/screen/full_screen/full_screen_screen.dart';
import 'package:call_court/ui/screen/preset/preset_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider(
      (ref) => GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: PresetScreen.routePath,
        builder: (_, __) => const PresetScreen(),
      ),
      GoRoute(
        path: FullScreenScreen.routePath,
        builder: (_, state) => FullScreenScreen(props: state.extra! as FullScreenScreenProps),
      ),
    ],
  ),
);
