import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/instructor/instructor_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/level/level_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/full_screen_loader.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final Widget childView;

  const HomeScreen({super.key, required this.childView});

  Future<void> _refreshData(BuildContext context) async {
    // Llamamos a los métodos de recarga de cada cubit
    final planCubit = context.read<PlanCubit>();
    final instructorCubit = context.read<InstructorCubit>();
    final levelCubit = context.read<LevelCubit>();

    await Future.wait([
      planCubit.getAllPlans(),
      instructorCubit.loadInstructors(),
      levelCubit.loadLevels(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final planState = context.watch<PlanCubit>().state;
    final instructorState = context.watch<InstructorCubit>().state;
    final nivelState = context.watch<LevelCubit>().state;
    // final classState = context.watch<ClassCubit>().state;

    final bool isPlanLoaded = planState is AllPlansLoaded;
    final bool isInstructorLoaded =
        instructorState.status == InstructorStatus.loaded;
    final bool islevelLoaded = nivelState.status == LevelStatus.loaded;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: (isPlanLoaded && isInstructorLoaded && islevelLoaded)
            ? childView
            : Center(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [Center(child: FullScreenLoader())],
                ),
              ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
