import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../servicios/auth_service.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/validadores.dart';
import '../../utils/constantes.dart';
import '../administrador/panel_principal.dart';

class LoginAdminPantalla extends StatefulWidget {
  const LoginAdminPantalla({Key? key}) : super(key: key);

  @override
  _LoginAdminPantallaState createState() => _LoginAdminPantallaState();
}

class _LoginAdminPantallaState extends State<LoginAdminPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _cargando = false;
  bool _obscureText = true;

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.iniciarSesionAdmin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PanelPrincipalPantalla()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Iniciar Sesión - Administrador',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(Constantes.primaryColor),
        elevation: 0,
        centerTitle: true,
      ),
      body: _cargando
          ? const IndicadorCarga(mensaje: 'Iniciando sesión...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Logo CTC
                  Center(
                    child: Image.asset(
                      'imagen/ctc-logo1.png',
                      width: 200,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título
                  Text(
                    'Panel Administrativo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(Constantes.textColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tus credenciales para continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Formulario de login
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CampoTexto(
                          label: 'Correo Electrónico',
                          controller: _emailController,
                          validator: Validadores.validarEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) =>
                              Validadores.validarRequerido(value, 'contraseña'),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(Constantes.primaryColor),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Botón de login
                        BotonPersonalizado(
                          texto: 'Iniciar Sesión',
                          onPressed: _iniciarSesion,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
