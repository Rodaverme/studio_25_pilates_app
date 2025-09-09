import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';


class LessonsToday extends StatelessWidget {
  const LessonsToday({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.pilatesClass,
    required this.instructor,
    required this.level,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final PilatesClass pilatesClass;
  final String instructor;
  final String level;

  @override
  Widget build(BuildContext context) {
    final horaInicio =
        "${pilatesClass.date.hour.toString().padLeft(2, '0')}:${pilatesClass.date.minute.toString().padLeft(2, '0')}";
    final horaFin =
        "${pilatesClass.date.add(pilatesClass.duracion).hour.toString().padLeft(2, '0')}:"
        "${pilatesClass.date.add(pilatesClass.duracion).minute.toString().padLeft(2, '0')}";

    
  

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
                        pilatesClass.nombre,
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
                      '$horaInicio - $horaFin',
                      style: textStyle.titleLarge?.copyWith(
                        color: AppColors.almendra,
                      ),
                    ),
                    Text(
                      '${pilatesClass.cuposOcupados}/${pilatesClass.cupoMaximo} Cupos',
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
