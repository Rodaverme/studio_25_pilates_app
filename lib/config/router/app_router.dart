import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
  ],
);
