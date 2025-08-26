import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';

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
    final monthYear = DateFormat("MMMM yyyy", "es").format(_focusedDay);

    return Column(
      children: [
        Text(
          monthYear[0].toUpperCase() + monthYear.substring(1),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomCardsType1(
            height: 65,
            child: Row(
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
          ),
        ),
        const SizedBox(height: 10),

        // 👇 Aquí mostramos la fecha seleccionada en formato "Lunes, 5 de julio"
        if (_selectedDay != null)
          Text(
            DateFormat("EEEE, d 'de' MMMM", "es").format(_selectedDay!),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        SizedBox(height: 20),
        CustomSegmentedControl(),
        SizedBox(height: 20),
      ],
    );
  }
}

class CustomSegmentedControl extends StatefulWidget {
  const CustomSegmentedControl({super.key});

  @override
  State<CustomSegmentedControl> createState() => _CustomSegmentedControlState();
}

class _CustomSegmentedControlState extends State<CustomSegmentedControl> {
  int _selectedIndex = 1; // 👈 Clases está activo por defecto

  final List<String> _items = ["Profesores", "Clases", "Eventos"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ), // 👈 margen a los lados
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (index) {
            final bool isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.piedra : AppColors.almendra,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.almendra, width: 2),
                ),
                child: Row(
                  children: [
                    Text(
                      _items[index],
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.almendra
                            : AppColors.piedra,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (index != 1)
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: isSelected
                            ? AppColors.almendra
                            : AppColors.piedra,
                        size: 18,
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
