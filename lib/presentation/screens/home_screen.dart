import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/full_screen_loader.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  @override
  Widget build(BuildContext context) {
    final planState = context.watch<PlanCubit>().state;

    return Scaffold(
      body: switch (planState) {
        PlanLoading() => const FullScreenLoader(),
        AllPlansLoaded() => childView,
        PlanError(:final message) => Center(child: Text('Error: $message')),
        _ => const FullScreenLoader(), // estado inicial o desconocido
      },
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
