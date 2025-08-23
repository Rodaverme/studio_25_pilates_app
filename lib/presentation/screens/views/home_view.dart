import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/clases.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Hola, ${client?.name}',
                  style: textStyle.titleLarge,
                ),
              ),
              // ---- Info Cards ----
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoCard(label: 'Clases este mes', value: '12'),
                    const SizedBox(width: 20),
                    _InfoCard(value: '4', label: 'Racha Actual'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ---- Próxima Clase ----
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Mi Próxima Clase',style: textStyle.titleLarge,),
              ),
              _NextClass(textStyle: textStyle, pilatesClass: listClass.first),
              const SizedBox(height: 20),

              // ---- Clases de Hoy ----
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Clases de Hoy'),
              ),
              SizedBox(
                height: 380, // 👈 altura fija suficiente
                child: ClassesCarousel(),
              ),
              const SizedBox(height: 20),

              // ---- Acciones rápidas ----
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
                    TextButton(onPressed: () {}, child: const Text('Tarjetas')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextClass extends StatelessWidget {
  const _NextClass({required this.textStyle, required this.pilatesClass});

  final TextTheme textStyle;
  final PilatesClass pilatesClass;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              // 👈 evita desbordes en nombres largos
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pilatesClass.nombre,
                    style: textStyle.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    pilatesClass.instructor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
  const ClassesCarousel({super.key});

  @override
  State<ClassesCarousel> createState() => _ClassesCarouselState();
}

class _ClassesCarouselState extends State<ClassesCarousel> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final pagesCount = (listClass.length / 2).ceil();

    return Column(
      children: [
        Expanded(
          // 👈 ahora el PageView usa todo el espacio disponible
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
                    pilatesClass: listClass[first],
                    textStyle: textStyle,
                    onTap: () =>
                        context.push('/Home/class/${listClass[first].id}'),
                  ),
                  const SizedBox(height: 12),
                  if (second < listClass.length)
                    LessonsToday(
                      pilatesClass: listClass[second],
                      textStyle: textStyle,
                      onTap: () =>
                          context.push('/Home/class/${listClass[second].id}'),
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
