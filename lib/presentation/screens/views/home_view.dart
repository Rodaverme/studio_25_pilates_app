import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/plan/plan_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final planState = context.read<PlanCubit>().state;
    if (planState is AllPlansLoaded) {
      context.read<ClassCubit>().loadClassesByPlan(planState.myPlan!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
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
                return Center(child: Text('Error :${state.message}'));
              }

              if (state is AllPlansLoaded) {
                return BlocBuilder<ClassCubit, ClassState>(
                  builder: (context, classState) {
                    if (classState is ClassByPlanLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (classState is ClassByPlanIdLoaded) {
                      final clases = classState.classPlan;

                      if (clases.isEmpty) {
                        return const Center(
                          child: Text("No tienes clases en este plan"),
                        );
                      }

                      return ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    'Hola, ${client?.name}',
                                    style: textStyle.titleLarge,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    _InfoCard(
                                      label: 'Clases este mes',
                                      value: '12',
                                    ),
                                    SizedBox(width: 20),
                                    _InfoCard(value: '4', label: 'racha'),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    'Mi Próxima Clase',
                                    style: textStyle.titleLarge,
                                  ),
                                ),
                                _NextClass(
                                  textStyle: textStyle,
                                  clase: clases.first,
                                ),
                                const SizedBox(height: 20),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Clases de Hoy'),
                                ),
                                SizedBox(
                                  height: 380,
                                  child: ClassesCarousel(list: clases),
                                ),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('Acciones Rápidas'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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

                    if (classState is ClassError) {
                      return Center(child: Text(classState.message));
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
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

class _NextClass extends StatelessWidget {
  const _NextClass({required this.textStyle, required this.clase});

  final TextTheme textStyle;
  final PilatesClass clase;

  @override
  Widget build(BuildContext context) {
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
                      clase.nombre,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      clase.instructor,
                      style: textStyle.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Hoy, ${clase.starTime}",
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
  final List<PilatesClass> list;

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
                    pilatesClass: widget.list[first],
                    textStyle: textStyle,
                    onTap: ()  {
                      
                       context.push('/Home/class/${widget.list[first].id}');
                    },
                    instructor: widget.list[first].instructor,
                    level: widget.list[first].nivel,
                  ),
                  const SizedBox(height: 12),
                  if (second < widget.list.length)
                    LessonsToday(
                      pilatesClass: widget.list[second],
                      textStyle: textStyle,
                      onTap: ()  {
                         context.push('/Home/class/${widget.list[second].id}');
                      },
                      instructor: widget.list[second].instructor,
                      level: widget.list[second].nivel,
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
