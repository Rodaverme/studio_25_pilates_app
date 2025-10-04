import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';
import 'package:studio_25_pilates_app/presentation/widgets/week_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String? _selectedInstructor;
  String? _selectedNivel;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/Logo6.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              /// 📅 Calendario con filtros dinámicos
              BlocBuilder<OcurrencesCubit, OcurrencesState>(
                builder: (context, state) {
                  return WeekCalendar(
                    onDaySelected: (day) {
                      context.read<OcurrencesCubit>().loadOcurrenceDay(day);
                    },
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedInstructor = filter['instructor'];
                        _selectedNivel = filter['nivel'];
                      });
                    },
                    occurrences: state.status == OcurrenceStatus.loaded
                        ? state.occurrencesDay
                        : [],
                  );
                },
              ),

              /// 📌 Lista de clases
              Expanded(
                child: BlocBuilder<OcurrencesCubit, OcurrencesState>(
                  builder: (context, state) {
                    if (state.status == OcurrenceStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == OcurrenceStatus.loaded) {
                      final now = DateTime.now();
                      final reservationLimit = now.add(
                        const Duration(minutes: 15),
                      );

                      // 👉 Filtrar las ocurrencias del día (mínimo 15 min antes)
                      var validOccurrences = state.occurrencesDay.where((o) {
                        return o.startTime.isAfter(reservationLimit);
                      }).toList();

                      // 👉 Filtro por instructor
                      if (_selectedInstructor != null &&
                          _selectedInstructor!.isNotEmpty) {
                        validOccurrences = validOccurrences
                            .where(
                              (o) => o.classSession!.instructor
                                  .toLowerCase()
                                  .contains(_selectedInstructor!.toLowerCase()),
                            )
                            .toList();
                      }

                      // 👉 Filtro por nivel
                      if (_selectedNivel != null &&
                          _selectedNivel!.isNotEmpty) {
                        validOccurrences = validOccurrences
                            .where(
                              (o) => o.classSession!.nivel
                                  .toLowerCase()
                                  .contains(_selectedNivel!.toLowerCase()),
                            )
                            .toList();
                      }

                      if (validOccurrences.isEmpty) {
                        return const Center(
                          child: Text("No hay clases para este día"),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: validOccurrences.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final c = validOccurrences[index];

                          return FadeInLeft(
                            child: LessonsToday(
                              ocurrence: c,
                              textStyle: textStyle,
                              onTap: () => context.push('/Home/class/${c.id}'),
                              instructor: c.classSession!.instructor,
                              level: c.classSession!.nivel,
                            ),
                          );
                        },
                      );
                    }

                    if (state.status == OcurrenceStatus.error) {
                      return Center(
                        child: Text(
                          'Ocurrio un problema al encontrar las clases',
                        ),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
