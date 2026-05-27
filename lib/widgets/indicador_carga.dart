import 'package:flutter/material.dart';
import '../utils/constantes.dart';

class IndicadorCarga extends StatelessWidget {
  final String mensaje;

  const IndicadorCarga({Key? key, this.mensaje = 'Cargando...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(Constantes.primaryColor)),
          ),
          SizedBox(height: 16),
          Text(
            mensaje,
            style: TextStyle(
              color: Color(Constantes.textColor),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}