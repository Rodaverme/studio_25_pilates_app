import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:studio_25_pilates_app/config/router/app_router.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/presentation/providers/blocs/class/class_cubit.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards.dart';

class ClassView extends StatelessWidget {
  static const name = 'class_screen';
  const ClassView({super.key, required this.classId});
  final String classId;

  @override
  Widget build(BuildContext context) {
    //todo implementacion de API buscar clase por ID
    return BlocBuilder<ClassCubit, ClassState>(
      builder: (context, state) {
        if (state is ClassLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassByIdLoaded) {
          final PilatesClass clase = state.clase;
          final fechaFormateada = DateFormat(
            "d MMMM ",
            'es_ES',
          ).format(clase.fechaHora);
          final horaInicio = DateFormat("HH:mm").format(clase.fechaHora);
          final horaFinal = DateFormat(
            "HH:mm",
          ).format(clase.fechaHora.add(clase.duracion));
          return Scaffold(
            appBar: AppBar(
              title: Text(clase.nombre),


              actions: [
                 Padding(
                  padding: EdgeInsets.all(10.0),
                  child: CustomCards(
                    width: 150,
                    height: 40,
                    child: Center(child: Text(clase.nivel)),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoCard([
                    fechaFormateada,
                    '$horaInicio - $horaFinal',
                    clase.sala,
                  ]),
                  _buildProgressSection(clase.cuposOcupados,clase.cupoMaximo),
                  _buildProfessorSection(),
                  _buildBenefitSection([
                    'Fuerza',
                    'Flexibilidad',
                    'Relajación',
                  ]),
                  _buildTextCardSection('Descripción', 'Mini bio profesor'),
                  _buildTextCardSection('Qué traer', 'Agua'),
                  _buildTextCardSection('Precio por clase', '120.000'),
                  _buildActionButtons(classId),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        } else if (state is ClassError) {
          return Center(child: Text(state.message));
        }
        return SizedBox.shrink();
      },
    );
  }

  /// Card con información simple en fila
  Widget _buildInfoCard(List<String> texts) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCards(
        width: double.maxFinite,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: texts
                .map(
                  (text) => Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18),
                      overflow: TextOverflow.ellipsis, // pone "..." si se pasa
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  /// Sección con barra de progreso
  Widget _buildProgressSection(int current, int total) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lugares Disponibles'),
              Text("$current/$total"),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: current / total,
            minHeight: 10,
            color: Colors.green,
            backgroundColor: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  /// Card con información del profesor
  Widget _buildProfessorSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Profesor'),
          CustomCards(
            width: double.maxFinite,
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Nombre profesor'),
                    SizedBox(height: 10),
                    Text('Mini bio del profesor'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const CustomCards(
                    width: 110,
                    height: 30,
                    child: Center(child: Text('Ver Perfil')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Lista de beneficios como tarjetas pequeñas
  Widget _buildBenefitSection(List<String> benefits) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Beneficios'),
          const SizedBox(height: 5),
          Row(
            children: benefits
                .map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CustomCards(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(child: Text(benefit)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Card con título y contenido de texto
  Widget _buildTextCardSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          CustomCards(
            height: 50,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(content),
            ),
          ),
        ],
      ),
    );
  }

  /// Botones de acción
  Widget _buildActionButtons(String id) {
    return Column(
      children: [
        _blackButton(
          'Reservar',
          width: 120,
          onTap: () {
            appRouter.push('/Home/class/$classId/reservation/$id');
          },
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _blackButton('Invitar Acompañante'),
            const SizedBox(width: 10),
            _blackButton('Cancelar'),
          ],
        ),
      ],
    );
  }

  /// Botón negro reutilizable
  Widget _blackButton(String text, {double? width, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
