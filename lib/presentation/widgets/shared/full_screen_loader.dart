import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  
  @override
  Widget build(BuildContext context) {
  

    final textStyle = Theme.of(context).textTheme;
    Stream<String> getLoadingMessage() {
      final message = <String>[
        'Espere un momento',
        'Cargando...',
        'Por favor espere',
        'Estamos trabajando en ello',
        'Un momento por favor',
        'Cargando datos',
        'Estamos casi listos',
        'Por favor, tenga paciencia',
        'Cargando información',
        'Estamos preparando algo especial para usted',
      ];

      return Stream.periodic(const Duration(milliseconds: 1200), (step) {
        return message[step];
      }).take(message.length);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Espere un momento',
            style: textStyle.titleLarge?.copyWith(fontSize: 20),
            
          ),
          
          const SizedBox(height: 20),
          const CircularProgressIndicator(strokeWidth: 4),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: getLoadingMessage(),
            builder: (context, snapshot) {
              
              if (!snapshot.hasData) return const SizedBox();
              return Text(
                snapshot.data!,
                style: textStyle.titleLarge?.copyWith(fontSize: 20),
              );
            },
          ),
        ],
      ),
    );
  }
}
