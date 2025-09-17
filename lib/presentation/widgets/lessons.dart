import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';


class LessonsToday extends StatelessWidget {
  const LessonsToday({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.ocurrence,
    required this.instructor,
    required this.level,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final Ocurrence ocurrence;
  final String instructor;
  final String level;

  @override
  Widget build(BuildContext context) {
    final horaInicio = DateFormat("HH:mm").format(ocurrence.startTime);
    final horaFinal = DateFormat("HH:mm").format(ocurrence.endTime);

    
  

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: AppColors.piedra.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.arena),
        ),
        child: Row(
          children: [
            /// 👉 Parte izquierda (info de la clase)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        ocurrence.classSession.nombre,
                        style: textStyle.titleLarge?.copyWith(
                          color: AppColors.almendra,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      instructor,
                      style: textStyle.titleLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$horaInicio - $horaFinal',
                      style: textStyle.titleLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    Text(
                      '${ocurrence.reservedCount}/${ocurrence.classSession.cupoMaximo} Cupos',
                      style: textStyle.titleLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 👉 Parte derecha (botones)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: Text(
                        level,
                        style: textStyle.bodySmall,
                      ),
                    ),

                    ElevatedButton(
                      onPressed: onTap,
                      child: const Text(
                        'Reservar',
                        style: TextStyle(color: Colors.white),
                      ),
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
