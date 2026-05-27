import 'package:flutter/material.dart';
import '../utils/constantes.dart';

class BotonPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool lleno;
  final bool deshabilitado;
  final Color? backgroundColor; // Hacerlo opcional
  final Color? textColor; // Color de texto opcional

  const BotonPersonalizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.lleno = true,
    this.deshabilitado = false,
    this.backgroundColor, // Ahora es opcional
    this.textColor, // Color de texto opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorFondo = backgroundColor ?? Color(Constantes.primaryColor);
    final colorTexto = textColor ?? (lleno ? Colors.white : Color(Constantes.primaryColor));

    return SizedBox(
      width: double.infinity, // Para que ocupe todo el ancho disponible
      child: ElevatedButton(
        onPressed: deshabilitado ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: lleno ? colorFondo : Colors.white,
          foregroundColor: colorTexto,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorFondo),
          ),
          elevation: 2,
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}