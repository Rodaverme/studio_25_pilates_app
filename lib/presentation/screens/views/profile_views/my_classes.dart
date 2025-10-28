import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';

class MyClasses extends StatelessWidget {
  const MyClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis clases')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),

          BlocBuilder<PlanCubit, PlanState>(
            builder: (context, state) {
              if (state.status == PlanStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == PlanStatus.loaded) {
                final plans = state.plans;
                final myPlan = state.myPlan; // 👈 el plan activo

                if (plans.isEmpty || myPlan == null) {
                  return const Center(child: Text("No tienes planes activos"));
                }

                // ✅ Filtramos el plan que coincide con myPlan
                final activePlan = plans.firstWhere(
                  (p) => p.id == myPlan.id,
                  orElse: () => myPlan,
                );

                final classes = activePlan.classes;

                if (classes == null || classes.isEmpty) {
                  return const Center(
                    child: Text("Tu plan no tiene clases asignadas"),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 👇 Nombre del plan
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Text(
                    //     activePlan.name,
                    //     style: textStyle.titleLarge?.copyWith(
                    //       fontSize: 25,
                    //       color: AppColors.almendra,
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        itemCount: classes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final c = classes[index];

                          return Lessons(
                            textStyle: textStyle,
                            onTap: () {
                              // context.push('/class/${c.id}');
                            },
                            classSession: c,
                            instructor: c.instructor,
                            level: c.nivel,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: Text("No hay clases en tu plan"));
            },
          ),
        ],
      ),
    );
  }
}

class Lessons extends StatelessWidget {
  const Lessons({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.classSession,
    required this.instructor,
    required this.level,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final PilatesClass classSession;
  final String instructor;
  final String level;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 170,
            decoration: BoxDecoration(
              color: AppColors.piedra.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.arena, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            classSession.nombre,
                            style: textStyle.titleLarge?.copyWith(
                              color: AppColors.almendra,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          instructor,
                          style: textStyle.titleLarge?.copyWith(
                            color: AppColors.almendra,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton(
                          onPressed: () {},
                          child: Text(level, style: textStyle.bodySmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
