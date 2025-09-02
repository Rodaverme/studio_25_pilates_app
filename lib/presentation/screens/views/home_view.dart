import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/domain/entities/instructor.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/instructor/instructor_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/level/level_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    final instructors = context.watch<InstructorCubit>().state.instructors;
    final levels = context.watch<LevelCubit>().state.levels;

    // ✅ Creamos un Map para acceso rápido por ID
    final instructorsMap = {for (var i in instructors) i.id.toString(): i};
    final levelsMap = {for (var i in levels) i.id.toString(): i};

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          BlocBuilder<PlanCubit, PlanState>(
            builder: (context, state) {
              if (state is PlanError) {
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is AllPlansLoaded) {
                final plans = state.plans;
                final myPlan = state.myPlan;

                if (plans.isEmpty) return const Center(child: Text(""));

                final planConClases = plans.firstWhere(
                  (plan) => myPlan != null && plan.id == myPlan.id,
                  orElse: () => plans.first,
                );

                final clases = planConClases.classes ?? [];

                // ✅ Preparamos la lista de clases con su instructor
                final clasesConInstructor = clases.map((c) {
                  return ClaseConInstructor(
                    pilatesClass: c,
                    instructor:
                        instructorsMap[c.instructor] ??
                        Instructor(
                          id: 0,
                          name: 'Desconocido',
                          email: '',
                          bio: '',
                          photoUrl: '',
                        ),
                    nivel:
                        levelsMap[c.nivel] ??
                        Nivel(id: 0, nombre: 'Principiante'),
                  );
                }).toList();

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Hola, ${client?.name}',
                              style: textStyle.titleLarge,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              _InfoCard(label: 'Clases este mes', value: '12'),
                              SizedBox(width: 20),
                              _InfoCard(value: '4', label: 'racha'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Mi Próxima Clase',
                              style: textStyle.titleLarge,
                            ),
                          ),
                          if (clasesConInstructor.isNotEmpty)
                            _NextClass(
                              textStyle: textStyle,
                              claseConInstructor: clasesConInstructor.first,
                            ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Clases de Hoy'),
                          ),
                          SizedBox(
                            height: 380,
                            child: ClassesCarousel(list: clasesConInstructor),
                          ),
                          // ---- Acciones rápidas ----
                          SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Acciones Rápidas'),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Mis Clases'),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Calendario'),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Tarjetas'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}

// Wrapper para asociar clase con instructor
class ClaseConInstructor {
  final PilatesClass pilatesClass;
  final Instructor instructor;
  final Nivel nivel;

  ClaseConInstructor({
    required this.pilatesClass,
    required this.instructor,
    required this.nivel,
  });
}

class _NextClass extends StatelessWidget {
  const _NextClass({required this.textStyle, required this.claseConInstructor});

  final TextTheme textStyle;
  final ClaseConInstructor claseConInstructor;

  @override
  Widget build(BuildContext context) {
    final c = claseConInstructor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.maxFinite,
        height: 130,
        decoration: BoxDecoration(
          color: AppColors.piedra,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.cafeNoir),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.pilatesClass.nombre,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      c.instructor.name,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Hoy, ${c.pilatesClass.fechaHora.hour.toString().padLeft(2, '0')}:${c.pilatesClass.fechaHora.minute.toString().padLeft(2, '0')}",
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size.width;
    return SizedBox(
      width: size * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: textStyle.titleLarge),
          Text(label, style: textStyle.bodyLarge),
        ],
      ),
    );
  }
}

class ClassesCarousel extends StatefulWidget {
  const ClassesCarousel({super.key, required this.list});
  final List<ClaseConInstructor> list;

  @override
  State<ClassesCarousel> createState() => _ClassesCarouselState();
}

class _ClassesCarouselState extends State<ClassesCarousel> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final pagesCount = (widget.list.length / 2).ceil();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pagesCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final first = index * 2;
              final second = first + 1;

              return Column(
                children: [
                  LessonsToday(
                    pilatesClass: widget.list[first].pilatesClass,
                    textStyle: textStyle,
                    onTap: () => context.push(
                      '/Home/class/${widget.list[first].pilatesClass.id}',
                    ),
                    listInstrutor: widget.list
                        .map((e) => e.instructor)
                        .toList(),
                    listLevel: widget.list.map((e) => e.nivel).toList(),
                  ),

                  const SizedBox(height: 12),
                  if (second < widget.list.length)
                    LessonsToday(
                      pilatesClass: widget.list[second].pilatesClass,
                      textStyle: textStyle,
                      onTap: () => context.push(
                        '/Home/class/${widget.list[second].pilatesClass.id}',
                      ),
                      listInstrutor: widget.list
                          .map((e) => e.instructor)
                          .toList(),
                      listLevel: widget.list.map((e) => e.nivel).toList(),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        SmoothPageIndicator(
          controller: _pageController,
          count: pagesCount,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.cafeNoir,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
          ),
        ),
      ],
    );
  }
}
