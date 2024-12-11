import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hadir_ui_desktop/hadir_ui_desktop.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: HadirRoutes.login,
    routes: [
      GoRoute(
        path: HadirRoutes.login,
        builder: (context, state) => const SizedBox(),
      ),
      ShellRoute(
        builder: (context, state, child) => RootLayout(child: child),
        routes: [
          GoRoute(
            path: HadirRoutes.dashboard,
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: HadirRoutes.courses,
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: HadirRoutes.courseDetails,
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: HadirRoutes.attendance,
            builder: (context, state) => const SizedBox(),
          ),
          GoRoute(
            path: HadirRoutes.settings,
            builder: (context, state) => const SizedBox(),
          ),
        ],
      ),
    ],
  );
}
