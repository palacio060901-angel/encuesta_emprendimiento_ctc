import 'package:flutter/material.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/seccion_formulario.dart';
import '../../utils/constantes.dart';
import 'campos_emprendimiento.dart';
import '../../modelos/estudiante.dart';
import '../../modelos/contacto.dart';
import '../../modelos/programa.dart';

class FormacionProgramaPantalla extends StatefulWidget {
  final Estudiante estudiante;
  final Contacto contacto;
  
  const FormacionProgramaPantalla({
    Key? key,
    required this.estudiante,
    required this.contacto,
  }) : super(key: key);

  @override
  _FormacionProgramaPantallaState createState() => _FormacionProgramaPantallaState();
}

class _FormacionProgramaPantallaState extends State<FormacionProgramaPantalla> {
  String _programaTecnico = '';
  String _moduloSemestre = '';
  final List<String> _cursosCortos = [];

  // Variables para validación
  bool _programaValido = false;
  bool _moduloValido = false;
  bool _cursosValidos = false;

  void _validarFormulario() {
    setState(() {
      _programaValido = _programaTecnico.isNotEmpty;
      _moduloValido = _moduloSemestre.isNotEmpty;
      _cursosValidos = _cursosCortos.isNotEmpty && 
                      (_cursosCortos.contains('No Aplica') || _cursosCortos.length > 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formación Académica'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            SeccionFormulario(
              titulo: 'Programa de Formación',
              children: [
                DropdownButtonFormField<String>(
                  value: _programaTecnico.isEmpty ? null : _programaTecnico,
                  decoration: InputDecoration(
                    labelText: 'Programa técnico vinculado *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorText: _programaValido ? null : 'Seleccione un programa',
                  ),
                  items: Constantes.programasTecnicos.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _programaTecnico = value!;
                      _validarFormulario();
                    });
                  },
                ),
                SizedBox(height: 20),
                
                DropdownButtonFormField<String>(
                  value: _moduloSemestre.isEmpty ? null : _moduloSemestre,
                  decoration: InputDecoration(
                    labelText: 'Módulo o semestre cursado *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    errorText: _moduloValido ? null : 'Seleccione módulo/semestre',
                  ),
                  items: Constantes.modulosSemestre.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _moduloSemestre = value!;
                      _validarFormulario();
                    });
                  },
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            SeccionFormulario(
              titulo: 'Cursos Cortos Realizados',
              children: [
                Text(
                  'Seleccione los cursos cortos que ha realizado en el CTC: *',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12),
                Text(
                  'Si no ha realizado ninguno, seleccione "No Aplica"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 16),
                
                ...Constantes.cursosCortos.map((curso) {
                  return CheckboxListTile(
                    title: Text(
                      curso,
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _cursosCortos.contains(curso),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          if (curso == 'No Aplica') {
                            // Si selecciona "No Aplica", limpiar otros cursos
                            _cursosCortos.clear();
                            _cursosCortos.add('No Aplica');
                          } else {
                            // Si selecciona otro curso, quitar "No Aplica"
                            _cursosCortos.remove('No Aplica');
                            _cursosCortos.add(curso);
                          }
                        } else {
                          _cursosCortos.remove(curso);
                        }
                        _validarFormulario();
                      });
                    },
                  );
                }).toList(),
                
                if (!_cursosValidos)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Debe seleccionar al menos un curso o "No Aplica"',
                      style: TextStyle(color: Colors.red, fontSize: 14),
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
                    texto: 'Siguiente',
                    onPressed: (_programaValido && _moduloValido && _cursosValidos) 
                        ? _siguiente 
                        : () {},
                    deshabilitado: !(_programaValido && _moduloValido && _cursosValidos),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _siguiente() {
    if (_programaTecnico.isNotEmpty && _moduloSemestre.isNotEmpty && _cursosValidos) {
      // Crear objeto Programa con los datos ingresados
      final programa = Programa(
        programaTecnico: _programaTecnico,
        moduloSemestre: _moduloSemestre,
        cursosCortos: _cursosCortos,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CamposEmprendimientoPantalla(
            estudiante: widget.estudiante,
            contacto: widget.contacto,
            programa: programa,
          ),
        ),
      );
    }
  }
}