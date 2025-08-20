import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/presentation/widgets/cards/custom_cards.dart';

class ClassView extends StatelessWidget {
  static const name = 'class_screen';
  const ClassView({super.key, required this.classId, });
   final String classId;

  final int current = 7;
  final int total = 10;

  @override
  Widget build(BuildContext context) {
    //todo implementacion de API buscar clase por ID
    return Scaffold(
      appBar: AppBar(
        title:  Text(classId),
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomCards(
              width: 90,
              height: 40,
              child: Center(child: Text('Experto')),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildInfoCard(['15 Julio', '18:00 - 19:30', 'Sala 1']),
            _buildProgressSection(),
            _buildProfessorSection(),
            _buildBenefitSection(['Fuerza', 'Flexibilidad', 'Relajación']),
            _buildTextCardSection('Descripción', 'Mini bio profesor'),
            _buildTextCardSection('Qué traer', 'Agua'),
            _buildTextCardSection('Precio por clase', '120.000'),
            _buildActionButtons(),
            const SizedBox(height: 80),
          ],
        ),
      ),
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
            children: texts.map((text) => Text(text)).toList(),
          ),
        ),
      ),
    );
  }

  /// Sección con barra de progreso
  Widget _buildProgressSection() {
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
                SizedBox(
                  height: 90,
                  width: 80,
                  child: Image.asset('assets/images/EjercicioP.png'),
                ),
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
  Widget _buildActionButtons() {
    return Column(
      children: [
        _blackButton('Reservar', width: 120),
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
  Widget _blackButton(String text, {double? width}) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
