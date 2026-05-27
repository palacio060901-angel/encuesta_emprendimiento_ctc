import 'package:flutter/material.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/seccion_formulario.dart';
import '../../widgets/campo_texto.dart';
import '../../utils/constantes.dart';
import 'resumen_encuesta.dart';
import '../../modelos/estudiante.dart';
import '../../modelos/contacto.dart';
import '../../modelos/programa.dart';
import '../../modelos/campos_emprendimiento.dart';

class CamposEmprendimientoPantalla extends StatefulWidget {
  final Estudiante estudiante;
  final Contacto contacto;
  final Programa programa;
  
  const CamposEmprendimientoPantalla({
    Key? key,
    required this.estudiante,
    required this.contacto,
    required this.programa,
  }) : super(key: key);

  @override
  _CamposEmprendimientoPantallaState createState() => _CamposEmprendimientoPantallaState();
}

class _CamposEmprendimientoPantallaState extends State<CamposEmprendimientoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _sugerenciasController = TextEditingController();
  final _direccionEmpresaController = TextEditingController();
  
  // Variables para las preguntas
  String _tieneIdeaNegocio = '';
  String _ideaEstructurada = '';
  String _tieneEmpresa = '';
  String _empresaFormalizada = '';
  String _tieneRecursos = '';
  String _aprenderDisenar = '';
  String _aprenderEstructurar = '';
  String _fortalecerEmpresa = '';

  // Lista de opciones SI/NO
  final List<String> _opcionesSiNo = ['SI', 'NO'];

  // Variables de validación
  bool _todasPreguntasRespondidas = false;

  Widget _preguntaSiNo(String titulo, String valorActual, Function(String) onChanged, {bool requerida = true}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: _opcionesSiNo.map((opcion) {
                return Expanded(
                  child: ListTile(
                    title: Text(opcion),
                    leading: Radio<String>(
                      value: opcion,
                      groupValue: valorActual,
                      onChanged: (value) {
                        onChanged(value!);
                        _validarFormulario();
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            if (requerida && valorActual.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Esta pregunta es obligatoria',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _validarFormulario() {
    final preguntasRequeridas = [
      _tieneIdeaNegocio,
      _ideaEstructurada,
      _tieneEmpresa,
      _tieneRecursos,
      _aprenderDisenar,
      _aprenderEstructurar,
      _fortalecerEmpresa,
    ];

    bool empresaCompleta = true;
    if (_tieneEmpresa == 'SI') {
      empresaCompleta = _empresaFormalizada.isNotEmpty && 
                       _direccionEmpresaController.text.trim().isNotEmpty;
    }

    setState(() {
      _todasPreguntasRespondidas = 
          !preguntasRequeridas.any((campo) => campo.isEmpty) && empresaCompleta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emprendimiento'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SeccionFormulario(
                titulo: 'Información de Emprendimiento',
                children: [
                  _preguntaSiNo(
                    '¿Tiene una idea de negocio? *',
                    _tieneIdeaNegocio,
                    (value) => setState(() => _tieneIdeaNegocio = value),
                  ),
                  
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    '¿Tiene estructurada su idea de negocio en algún documento? *',
                    _ideaEstructurada,
                    (value) => setState(() => _ideaEstructurada = value),
                  ),
                  
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    '¿Tiene empresa o negocio propio? *',
                    _tieneEmpresa,
                    (value) => setState(() => _tieneEmpresa = value),
                  ),
                  
                  // Preguntas condicionales si tiene empresa
                  if (_tieneEmpresa == 'SI') ...[
                    SizedBox(height: 16),
                    _preguntaSiNo(
                      '¿Su Empresa y/o negocio se encuentra Formalizada? *',
                      _empresaFormalizada,
                      (value) => setState(() => _empresaFormalizada = value),
                    ),
                    
                    SizedBox(height: 16),
                    CampoTexto(
                      label: 'Dirección de la empresa o enlace de tienda virtual *',
                      controller: _direccionEmpresaController,
                      onChanged: (value) => _validarFormulario(),
                      maxLines: 3,
                      validator: _tieneEmpresa == 'SI' 
                          ? (value) => value == null || value.isEmpty 
                              ? 'Este campo es obligatorio si tiene empresa' 
                              : null
                          : null,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Si es tienda virtual colocar el @ o enlace de la página',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    '¿Cuenta con recursos para financiar su idea de negocio o empresa? *',
                    _tieneRecursos,
                    (value) => setState(() => _tieneRecursos = value),
                  ),
                  
                  SizedBox(height: 24),
                  
                  Text(
                    'Interés en Formación - ¿Le gustaría aprender a:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(Constantes.textColor),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    'Diseñar ideas de negocio? *',
                    _aprenderDisenar,
                    (value) => setState(() => _aprenderDisenar = value),
                  ),
                  
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    'Estructurar ideas de negocio? *',
                    _aprenderEstructurar,
                    (value) => setState(() => _aprenderEstructurar = value),
                  ),
                  
                  SizedBox(height: 16),
                  
                  _preguntaSiNo(
                    'Fortalecer su empresa y/o unidad productiva? *',
                    _fortalecerEmpresa,
                    (value) => setState(() => _fortalecerEmpresa = value),
                  ),
                  
                  SizedBox(height: 24),
                  
                  CampoTexto(
                    label: '¿Qué le gustaría que el Centro Tecnológico de Cúcuta hiciera en temas de Emprendimiento?',
                    controller: _sugerenciasController,
                    maxLines: 5,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lluvia de ideas, no limites lo que piensas, todas las ideas son válidas',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              
              // Botones
              Row(
                children: [
                  Expanded(
                    child: BotonPersonalizado(
                      texto: 'Anterior',
                      onPressed: () => Navigator.pop(context),
                      lleno: false,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: BotonPersonalizado(
                      texto: 'Ver Resumen',
                      onPressed: _siguiente,
                      deshabilitado: !_todasPreguntasRespondidas,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              if (!_todasPreguntasRespondidas)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Por favor responda todas las preguntas obligatorias (*)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _siguiente() {
    if (_formKey.currentState!.validate() && _todasPreguntasRespondidas) {
      // Crear objeto CamposEmprendimiento con los datos ingresados
      final emprendimiento = CamposEmprendimiento(
        tieneIdeaNegocio: _tieneIdeaNegocio,
        ideaEstructurada: _ideaEstructurada,
        tieneEmpresa: _tieneEmpresa,
        empresaFormalizada: _empresaFormalizada,
        direccionEmpresa: _direccionEmpresaController.text,
        tieneRecursos: _tieneRecursos,
        aprenderDisenar: _aprenderDisenar,
        aprenderEstructurar: _aprenderEstructurar,
        fortalecerEmpresa: _fortalecerEmpresa,
        sugerencias: _sugerenciasController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResumenEncuestaPantalla(
            estudiante: widget.estudiante,
            contacto: widget.contacto,
            programa: widget.programa,
            emprendimiento: emprendimiento,
          ),
        ),
      );
    }
  }
}