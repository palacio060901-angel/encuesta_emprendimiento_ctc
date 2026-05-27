import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../servicios/firebase_service.dart';
import '../../modelos/estudiante.dart';
import '../../modelos/contacto.dart';
import '../../modelos/programa.dart';
import '../../modelos/campos_emprendimiento.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/constantes.dart';

class ResumenEncuestaPantalla extends StatefulWidget {
  final Estudiante estudiante;
  final Contacto contacto;
  final Programa programa;
  final CamposEmprendimiento emprendimiento;
  
  const ResumenEncuestaPantalla({
    Key? key,
    required this.estudiante,
    required this.contacto,
    required this.programa,
    required this.emprendimiento,
  }) : super(key: key);

  @override
  _ResumenEncuestaPantallaState createState() => _ResumenEncuestaPantallaState();
}

class _ResumenEncuestaPantallaState extends State<ResumenEncuestaPantalla> {
  bool _enviando = false;
  bool _enviado = false;

  Future<void> _enviarEncuesta() async {
    setState(() => _enviando = true);
    
    try {
      final firebaseService = Provider.of<FirebaseService>(context, listen: false);
      await firebaseService.guardarEncuesta(
        estudiante: widget.estudiante,
        contacto: widget.contacto,
        programa: widget.programa,
        emprendimiento: widget.emprendimiento,
      );
      
      setState(() {
        _enviando = false;
        _enviado = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Encuesta enviada exitosamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      
    } catch (e) {
      setState(() => _enviando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al enviar encuesta: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _itemResumen(String titulo, String valor, {bool esLista = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$titulo:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(Constantes.textColor),
            ),
          ),
          SizedBox(height: 4),
          Text(
            valor.isEmpty ? 'No aplica' : valor,
            style: TextStyle(
              fontSize: esLista ? 14 : 16,
              color: Colors.grey[700],
            ),
          ),
          Divider(height: 20, color: Colors.grey[300]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_enviando) {
      return Scaffold(
        appBar: AppBar(title: Text('Enviando Encuesta')),
        body: IndicadorCarga(mensaje: 'Enviando encuesta a la base de datos...'),
      );
    }

    if (_enviado) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 80, color: Colors.green),
                SizedBox(height: 24),
                Text(
                  '¡Encuesta Enviada Exitosamente!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(Constantes.textColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Gracias por participar en la encuesta de emprendimiento del Centro Tecnológico de Cúcuta.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 32),
                BotonPersonalizado(
                  texto: 'Volver al Inicio',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Encuesta'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Encabezado
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.assignment, size: 50, color: Color(Constantes.primaryColor)),
                          SizedBox(height: 12),
                          Text(
                            'Resumen Final de la Encuesta',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.textColor),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Revise toda la información antes de enviar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Datos Personales (USANDO DATOS REALES)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '👤 Datos Personales',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.primaryColor),
                            ),
                          ),
                          SizedBox(height: 12),
                          _itemResumen('Tipo de Identificación', widget.estudiante.tipoIdentificacion),
                          _itemResumen('Número de Identificación', widget.estudiante.numeroIdentificacion),
                          _itemResumen('Nombres Completos', '${widget.estudiante.nombres} ${widget.estudiante.apellidos}'),
                          _itemResumen('Edad', widget.estudiante.edad.toString()),
                          _itemResumen('Dirección', widget.estudiante.direccionResidencia),
                          _itemResumen('Barrio', widget.estudiante.barrio),
                          _itemResumen('Comuna', widget.estudiante.comuna),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Contacto y Ubicación (USANDO DATOS REALES)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📞 Contacto y Condiciones',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.primaryColor),
                            ),
                          ),
                          SizedBox(height: 12),
                          _itemResumen('Teléfono', widget.contacto.telefono),
                          _itemResumen('Registro Sisbén', widget.contacto.tieneSisben ? 'Sí' : 'No'),
                          if (widget.contacto.tieneSisben)
                            _itemResumen('Categoría Sisbén', widget.contacto.categoriaSisben),
                          _itemResumen('Condición de Vulnerabilidad', widget.contacto.vulnerabilidad),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Programa de Formación (USANDO DATOS REALES)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎓 Formación Académica',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.primaryColor),
                            ),
                          ),
                          SizedBox(height: 12),
                          _itemResumen('Programa Técnico', widget.programa.programaTecnico),
                          _itemResumen('Módulo/Semestre', widget.programa.moduloSemestre),
                          _itemResumen('Cursos Cortos Realizados', widget.programa.cursosCortos.join('\n• '), esLista: true),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Emprendimiento (USANDO DATOS REALES)
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡 Emprendimiento',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.primaryColor),
                            ),
                          ),
                          SizedBox(height: 12),
                          _itemResumen('Idea de Negocio', widget.emprendimiento.tieneIdeaNegocio),
                          _itemResumen('Idea Estructurada en Documento', widget.emprendimiento.ideaEstructurada),
                          _itemResumen('Empresa o Negocio Propio', widget.emprendimiento.tieneEmpresa),
                          if (widget.emprendimiento.tieneEmpresa == 'SI') ...[
                            _itemResumen('Empresa Formalizada', widget.emprendimiento.empresaFormalizada),
                            _itemResumen('Dirección/Empresa', widget.emprendimiento.direccionEmpresa),
                          ],
                          _itemResumen('Recursos para Financiar', widget.emprendimiento.tieneRecursos),
                          _itemResumen('Aprender a Diseñar Ideas', widget.emprendimiento.aprenderDisenar),
                          _itemResumen('Aprender a Estructurar Ideas', widget.emprendimiento.aprenderEstructurar),
                          _itemResumen('Fortalecer Empresa', widget.emprendimiento.fortalecerEmpresa),
                          _itemResumen('Sugerencias para el CTC', widget.emprendimiento.sugerencias),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Botones
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
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
                    texto: 'Enviar Encuesta',
                    onPressed: _enviarEncuesta,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}