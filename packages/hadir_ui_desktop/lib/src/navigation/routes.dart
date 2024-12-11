class HadirRoutes {
  const HadirRoutes._();

  static const String login = '/login';
  static const String dashboard = '/';
  static const String courses = '/courses';
  static const String courseDetails = '/courses/:id';
  static const String attendance = '/attendance';
  static const String settings = '/settings';

  // Named route paths
  static String courseDetailsPath(String courseId) => '/courses/$courseId';
}
