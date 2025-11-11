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

    final bool isInPlan = ocurrence.isInPlan;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        height: 170,
        decoration: BoxDecoration(
          color: AppColors.piedra.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isInPlan ? AppColors.cafeNoir : AppColors.arena,
            width: isInPlan ? 4 : 1.5,
          ),
        ),
        child: Row(
          children: [
            /// 👉 Parte izquierda (info)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        ocurrence.classSession!.nombre,
                        style: textStyle.titleLarge?.copyWith(
                          color: AppColors.almendra,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isInPlan) ...[
                      const SizedBox(height: 5),
                      Text(
                        'Incluido en tu plan',
                        style: textStyle.bodySmall?.copyWith(
                          color: AppColors.cafeNoir,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${0}/${ocurrence.classSession?.cupoMaximo} Cupos',
                      style: textStyle.bodyLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    Text(
                      '$horaInicio - $horaFinal',
                      style: textStyle.bodyLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    Text(
                      instructor,
                      style: textStyle.bodyLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            /// 👉 Parte derecha (botones)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: const Size.fromHeight(35),
                      ),
                      child: Text(
                        level,
                        style: textStyle.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        minimumSize: const Size.fromHeight(40),
                      ),
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
