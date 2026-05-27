import 'package:flutter/material.dart';
import 'login/login_admin.dart';
import 'encuesta/datos_personales.dart';
import '../utils/constantes.dart';
import '../widgets/boton_personalizado.dart';

class InicioPantalla extends StatelessWidget {
  const InicioPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity, 
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              // Logo CTC como imagen PNG real
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'imagen/ctc-logo1.png',
                  width: 280,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 40),
              
              Text(
                'Sistema de Encuestas\nde Emprendimiento CTC',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(Constantes.textColor),
                ),
              ),
              SizedBox(height: 48),
              
              // Contenedor para los botones con ancho limitado en pantallas grandes
              Container(
                constraints: BoxConstraints(maxWidth: 400), 
                child: Column(
                  children: [
                    BotonPersonalizado(
                      texto: '🎓 Estudiante',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DatosPersonalesPantalla()),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    
                    BotonPersonalizado(
                      texto: '👨‍💼 Administrador',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginAdminPantalla()),
                        );
                      },
                      lleno: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}