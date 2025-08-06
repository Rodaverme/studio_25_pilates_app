import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(path: '/', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/resetPassword',
      builder: (context, state) => ResetPasswordScreen(),
    ),
    GoRoute(path: '/register', builder: (context, state) => RegisterScreen()),
    GoRoute(path: '/home-screen',builder: (context, state) => HomeScreen(),)
  ],
);
