import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:studio_25_pilates_app/domain/clases.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/auth/auth_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final client = context.watch<AuthCubit>().state.client;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Hola, ${client?.name}')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Mi Próxima Clase'),
          ),
          _NextClass(textStyle: textStyle, pilatesClass: listClass.first),
          const SizedBox(height: 20),

          // ---- Clases de Hoy ----
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Clases de Hoy'),
          ),
          SizedBox(
            height: 380,
             // 👈 altura fija para tarjetas
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (listClass.length / 2).ceil(),

              itemBuilder: (context, index) {
                final size = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: size, // 👈 ancho de cada tarjeta
                  child: ClassesCarousel(),
                );
              },
            ),
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
                TextButton(onPressed: () {}, child: const Text('Mis Clases')),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Calendario')),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Tarjetas')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LessonsToday extends StatelessWidget {
  const LessonsToday({super.key, 
    required this.textStyle,
    required this.onTap,
    required this.pilatesClass,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final PilatesClass pilatesClass;

  @override
  Widget build(BuildContext context) {
    final horaInicio =
        "${pilatesClass.fechaHora.hour}:${pilatesClass.fechaHora.minute.toString().padLeft(2, '0')}";
    final horaFin =
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).hour}:"
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    'assets/images/EjercicioP.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  // 👈 para que el texto se adapte
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pilatesClass.nombre,
                          style: textStyle.titleLarge,
                          maxLines: 1, // 👈 máximo una línea
                          overflow: TextOverflow.ellipsis, // 👈 agrega "..."
                        ),
                        Text(
                          pilatesClass.instructor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            pilatesClass.nivel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$horaInicio - $horaFin'),
                  Spacer(),
                  Text(
                    '${pilatesClass.cuposOcupados}/${pilatesClass.cupoMaximo} Cupos',
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          'Reservar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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

class _NextClass extends StatelessWidget {
  const _NextClass({required this.textStyle, required this.pilatesClass});

  final TextTheme textStyle;
  final PilatesClass pilatesClass;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.maxFinite,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(
                'assets/images/EjercicioP.png',
                fit: BoxFit.cover,
              ),
            ),
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
    return Container(
      height: 130,
      width: size * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: textStyle.titleLarge),
          Text(label),
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
        SizedBox(
          height: 350, // alto para tus columnas
          child: PageView.builder(
            controller: _pageController,
            itemCount: pagesCount,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final first = index * 2;
              final second = first + 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
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
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: pagesCount,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.green,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 6,
          ),
        ),
      ],
    );
  }
}
