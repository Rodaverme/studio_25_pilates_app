import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/providers/cubits/ocurrence/ocurrences_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/lessons.dart';
import 'package:studio_25_pilates_app/presentation/widgets/week_calendar.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

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
              /// 📅 Calendario
              WeekCalendar(
                onDaySelected: (day) {
                  context.read<OcurrencesCubit>().loadOcurrenceDay(day);
                },
              ),

              /// 📌 Lista de clases
              Expanded(
                child: BlocBuilder<OcurrencesCubit, OcurrencesState>(
                  builder: (context, state) {
                    if (state.status == ClassStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == OcurrenceStatus.loaded) {
                      if (state.occurrencesDay.isEmpty) {
                        return const Center(
                          child: Text("No hay clases para este día"),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: state.occurrencesDay.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 20),
                        itemBuilder: (context, index) {
                          final c = state.occurrencesDay[index];

                          return FadeInLeft(
                            child: LessonsToday(
                              ocurrence: c,
                              textStyle: textStyle,
                              onTap: () => context.push('/Home/class/${c.id}'),
                              instructor: c.classSession.instructor,
                              level: c.classSession.nivel,
                            ),
                          );
                        },
                      );
                    }

                    if (state.status == OcurrenceStatus.error) {
                      return Center(child: Text(state.errorMessage!));
                    }

                    return const Center(
                      child:  Center(child: CircularProgressIndicator()),
                    );
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
