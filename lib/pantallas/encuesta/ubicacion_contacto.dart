import 'package:flutter/material.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/seccion_formulario.dart';
import '../../utils/constantes.dart';
import '../../utils/validadores.dart';
import 'formacion_programa.dart';
import '../../modelos/estudiante.dart';
import '../../modelos/contacto.dart';

class UbicacionContactoPantalla extends StatefulWidget {
  final Estudiante estudiante;
  
  const UbicacionContactoPantalla({
    Key? key,
    required this.estudiante,
  }) : super(key: key);

  @override
  _UbicacionContactoPantallaState createState() => _UbicacionContactoPantallaState();
}

class _UbicacionContactoPantallaState extends State<UbicacionContactoPantalla> {
  final _formKey = GlobalKey<FormState>();
  final _telefonoController = TextEditingController();
  bool _tieneSisben = false;
  String _categoriaSisben = '';
  String _vulnerabilidad = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacto y Ubicación'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SeccionFormulario(
                titulo: 'Información de Contacto y Condiciones',
                children: [
                  CampoTexto(
                    label: 'Teléfono *',
                    controller: _telefonoController,
                    validator: Validadores.validarTelefono,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20),
                  
                  // Sisbén
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¿Está registrado en Sisbén? *',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text('Sí'),
                                  leading: Radio<bool>(
                                    value: true,
                                    groupValue: _tieneSisben,
                                    onChanged: (value) {
                                      setState(() => _tieneSisben = value!);
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text('No'),
                                  leading: Radio<bool>(
                                    value: false,
                                    groupValue: _tieneSisben,
                                    onChanged: (value) {
                                      setState(() => _tieneSisben = value!);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          if (_tieneSisben) ...[
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _categoriaSisben.isEmpty ? null : _categoriaSisben,
                              decoration: InputDecoration(
                                labelText: 'Categoría Sisbén *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: Constantes.categoriasSisben.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('Categoría $value'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() => _categoriaSisben = value!);
                              },
                              validator: _tieneSisben 
                                  ? (value) => value == null ? 'Seleccione categoría Sisbén' : null
                                  : null,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Vulnerabilidad
                  DropdownButtonFormField<String>(
                    value: _vulnerabilidad.isEmpty ? null : _vulnerabilidad,
                    decoration: InputDecoration(
                      labelText: 'Condición de Vulnerabilidad *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: Constantes.vulnerabilidades.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _vulnerabilidad = value!);
                    },
                    validator: (value) => value == null ? 'Seleccione condición de vulnerabilidad' : null,
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
                      onPressed: _siguiente,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _siguiente() {
    if (_formKey.currentState!.validate()) {
      // Validación adicional para Sisbén
      if (_tieneSisben && _categoriaSisben.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Si está en Sisbén, debe seleccionar la categoría'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Crear objeto Contacto con los datos ingresados
      final contacto = Contacto(
        telefono: _telefonoController.text,
        tieneSisben: _tieneSisben,
        categoriaSisben: _categoriaSisben,
        vulnerabilidad: _vulnerabilidad,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormacionProgramaPantalla(
            estudiante: widget.estudiante,
            contacto: contacto,
          ),
        ),
      );
    }
  }
}