import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const WeekCalendar({super.key, required this.onDaySelected});

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDaySelected(_selectedDay!); // 👈 carga de una vez el día actual
    });
  }

  List<DateTime> get _daysOfWeek {
    final firstDayOfWeek = _focusedDay.subtract(
      Duration(days: _focusedDay.weekday % 7),
    );
    return List.generate(7, (i) => firstDayOfWeek.add(Duration(days: i)));
  }

  void _nextWeek() {
    setState(() {
      _focusedDay = _focusedDay.add(const Duration(days: 7));
    });
  }

  void _previousWeek() {
    setState(() {
      _focusedDay = _focusedDay.subtract(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat("MMMM, yyyy", "es").format(_focusedDay);

    return Column(
      children: [
        Text(
          monthYear[0].toUpperCase() + monthYear.substring(1),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousWeek,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _daysOfWeek.map((day) {
                  final isSelected =
                      _selectedDay != null &&
                      day.day == _selectedDay!.day &&
                      day.month == _selectedDay!.month &&
                      day.year == _selectedDay!.year;

                  final isToday =
                      day.day == DateTime.now().day &&
                      day.month == DateTime.now().month &&
                      day.year == DateTime.now().year;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = day;
                      });
                      widget.onDaySelected(day);
                    },
                    child: Column(
                      children: [
                        Text(
                          DateFormat.E("es").format(day),
                          style: TextStyle(
                            fontWeight: (isSelected || isToday)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Text(
                          "${day.day}",
                          style: TextStyle(
                            fontWeight: (isSelected || isToday)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              onPressed: _nextWeek,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
