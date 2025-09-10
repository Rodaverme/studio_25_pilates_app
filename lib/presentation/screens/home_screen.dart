import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/cubits.dart';
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
   
    
    final bool isPlanLoaded = planState is AllPlansLoaded;
   

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: (isPlanLoaded  )
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
