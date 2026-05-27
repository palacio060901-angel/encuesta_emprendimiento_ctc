import 'package:flutter/material.dart';

class SeccionFormulario extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;

  const SeccionFormulario({
    Key? key,
    required this.titulo,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        SizedBox(height: 20),
        ...children,
      ],
    );
  }
}