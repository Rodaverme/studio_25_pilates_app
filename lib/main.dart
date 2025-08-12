import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/infrastructure/datasource/auth_datasource_impl.dart';
import 'package:studio_25_pilates_app/infrastructure/repositories/auth_respository_impl.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/logout/logout_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
          create: (_) => LogoutCubit(
            authRepository: AuthRespositoryImpl(
              datasource: AuthDatasourceImpl(),
            ),
          ),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
