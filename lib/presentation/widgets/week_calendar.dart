import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';

class WeekCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final Function(Map<String, dynamic>) onFilterChanged;
  final List<Ocurrence> occurrences; // 👈 se inyectan ocurrencias dinámicas

  const WeekCalendar({
    super.key,
    required this.onDaySelected,
    required this.onFilterChanged,
    required this.occurrences,
  });

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
      widget.onDaySelected(_selectedDay!); // carga inicial
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

    // 👉 Sacamos instructores y niveles únicos de las ocurrencias
    final instructors = widget.occurrences
        .map((o) => o.classSession?.instructor)
        .where((i) => i!.isNotEmpty)
        .toSet()
        .toList();

    final levels = widget.occurrences
        .map((o) => o.classSession?.nivel)
        .where((n) => n!.isNotEmpty)
        .toSet()
        .toList();

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

        if (_selectedDay != null)
          Text(
            DateFormat("EEEE, d 'de' MMMM", "es").format(_selectedDay!),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),

        const SizedBox(height: 20),

        // 👇 Control de filtros dinámicos
        CustomSegmentedControl(
          instructors: instructors,
          levels: levels,
          onFilterChanged: (filter) {
            setState(() {});
            widget.onFilterChanged(filter);
          },
        ),
      ],
    );
  }
}

class CustomSegmentedControl extends StatefulWidget {
  final List<String?> instructors;
  final List<String?> levels;
  final Function(Map<String, dynamic>) onFilterChanged;

  const CustomSegmentedControl({
    super.key,
    required this.instructors,
    required this.levels,
    required this.onFilterChanged,
  });

  @override
  State<CustomSegmentedControl> createState() => _CustomSegmentedControlState();
}

class _CustomSegmentedControlState extends State<CustomSegmentedControl> {
  int _selectedIndex = 1; // Clases activo por defecto
  String? _selectedInstructor;
  String? _selectedNivel;

  final List<String> _items = ["Instructores", "Clases", "Niveles"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 👉 Botones de segmento
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
        ),

        const SizedBox(height: 10),

        // 👇 Dropdown dinámico según segmento
        if (_selectedIndex == 0) // Instructores
          DropdownButton<String>(
            hint: const Text("Seleccionar Instructor"),
            value: _selectedInstructor,
            onChanged: (value) {
              setState(() {
                _selectedInstructor = value;
              });
              widget.onFilterChanged({
                "instructor": value,
                "nivel": _selectedNivel,
              });
            },
            items: widget.instructors.map((i) {
              return DropdownMenuItem(value: i, child: Text(i!));
            }).toList(),
          ),

        if (_selectedIndex == 2) // Niveles
          DropdownButton<String>(
            hint: const Text("Seleccionar Nivel"),
            value: _selectedNivel,
            onChanged: (value) {
              setState(() {
                _selectedNivel = value;
              });
              widget.onFilterChanged({
                "instructor": _selectedInstructor,
                "nivel": value,
              });
            },
            items: widget.levels.map((n) {
              return DropdownMenuItem(value: n, child: Text(n!));
            }).toList(),
          ),
        if (_selectedInstructor != null || _selectedNivel != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedInstructor = null;
                  _selectedNivel = null;
                });
                widget.onFilterChanged({"instructor": null, "nivel": null});
              },
              icon: const Icon(Icons.clear, color: Colors.red),
              label: const Text(
                "Borrar filtros",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
