import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards_type1.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';

class WeekCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;
  final Function(Map<String, dynamic>) onFilterChanged;
  final List<Ocurrence> occurrences;

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

  String? _selectedInstructor;
  String? _selectedNivel;

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

    // 🧩 Sacamos instructores y niveles únicos desde el backend
    final instructors = widget.occurrences
        .map((o) => o.classSession?.instructor)
        .where((i) => i != null && i.isNotEmpty)
        .toSet()
        .toList();

    final levels = widget.occurrences
        .map((o) => o.classSession?.nivel)
        .where((n) => n != null && n.isNotEmpty)
        .toSet()
        .toList();

    return Column(
      children: [
        /// 📅 Mes actual
        Text(
          monthYear[0].toUpperCase() + monthYear.substring(1),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        /// 📆 Días de la semana
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

        /// 📅 Día seleccionado
        if (_selectedDay != null)
          Text(
            DateFormat("EEEE, d 'de' MMMM", "es").format(_selectedDay!),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),

        const SizedBox(height: 20),

        /// 🎚️ Filtros de Instructor y Nivel
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedInstructor,
                  decoration: InputDecoration(
                    labelText: "Instructor",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.piedra, width: 1.5),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  hint: const Text("Seleccionar"),
                  items: instructors.map((i) {
                    return DropdownMenuItem(
                      value: i,
                      child: Text(i ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedInstructor = value;
                    });
                    widget.onFilterChanged({
                      "instructor": value,
                      "nivel": _selectedNivel,
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedNivel,
                  decoration: InputDecoration(
                    labelText: "Nivel",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: AppColors.piedra, width: 1.5),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  hint: const Text("Seleccionar"),
                  items: levels.map((n) {
                    return DropdownMenuItem(
                      value: n,
                      child: Text(n ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedNivel = value;
                    });
                    widget.onFilterChanged({
                      "instructor": _selectedInstructor,
                      "nivel": value,
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        /// ❌ Botón de borrar filtros (opcional)
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
