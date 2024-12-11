import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hadir_ui_desktop/hadir_ui_desktop.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: _calculateSelectedIndex(context),
        onChanged: (index) => _onNavigationChanged(context, index),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Dashboard'),
            body: const SizedBox.shrink(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.library),
            title: const Text('Courses'),
            body: const SizedBox.shrink(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.calendar),
            title: const Text('Attendance'),
            body: const SizedBox.shrink(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const SizedBox.shrink(),
          ),
        ],
      ),
      content: child,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(HadirRoutes.courses)) return 1;
    if (location.startsWith(HadirRoutes.attendance)) return 2;
    if (location.startsWith(HadirRoutes.settings)) return 3;
    return 0; // Dashboard
  }

  void _onNavigationChanged(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(HadirRoutes.dashboard);
      case 1:
        context.go(HadirRoutes.courses);
      case 2:
        context.go(HadirRoutes.attendance);
      case 3:
        context.go(HadirRoutes.settings);
    }
  }
}
