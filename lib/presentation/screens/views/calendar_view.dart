import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/screens/views/home_view.dart';
import 'package:studio_25_pilates_app/presentation/widgets/week_calendar.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendario')),
      body: Column(
        children: [
          WeekCalendar(
            onDaySelected: (day) {
              context.read<ClassCubit>().loadClasses(day);
            },
          ),
          Expanded(
            child: BlocBuilder<ClassCubit, ClassState>(
              builder: (context, state) {
                if (state is ClassLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ClassLoaded) {
                  if (state.classes.isEmpty) {
                    return const Center(
                      child: Text("No hay clases para este día"),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.classes.length,
                    itemBuilder: (context, index) {
                      final textStyle = Theme.of(context).textTheme;
                      final c = state.classes[index];
                  
                      return FadeInLeftBig(
                        child: LessonsToday(
                          pilatesClass: c,
                          textStyle: textStyle,
                          onTap: () => context.push('/Home/class/${c.id}'),
                        ),
                      );
                    },
                  );
                } else if (state is ClassError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text("Selecciona un día"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
