import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class LessonsToday extends StatelessWidget {
  const LessonsToday({
    super.key,
    required this.textStyle,
    required this.onTap,
    required this.pilatesClass,
  });

  final TextTheme textStyle;
  final void Function()? onTap;
  final PilatesClass pilatesClass;

  @override
  Widget build(BuildContext context) {
    final horaInicio =
        "${pilatesClass.fechaHora.hour.toString().padLeft(2, '0')}:${pilatesClass.fechaHora.minute.toString().padLeft(2, '0')}";
    final horaFin =
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).hour.toString().padLeft(2, '0')}:"
        "${pilatesClass.fechaHora.add(pilatesClass.duracion).minute.toString().padLeft(2, '0')}";

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
                      pilatesClass.instructor,
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
                        pilatesClass.nivel,
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
