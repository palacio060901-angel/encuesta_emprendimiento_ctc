import 'package:flutter/material.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/seccion_formulario.dart';
import '../../utils/constantes.dart';
import '../../utils/validadores.dart';
import '../../pantallas/encuesta/ubicacion_contacto.dart';
import '../../modelos/estudiante.dart';

class DatosPersonalesPantalla extends StatefulWidget {
  const DatosPersonalesPantalla({Key? key}) : super(key: key);

  @override
  _DatosPersonalesPantallaState createState() => _DatosPersonalesPantallaState();
}

class _DatosPersonalesPantallaState extends State<DatosPersonalesPantalla> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final _tipoIdentificacionController = TextEditingController();
  final _numeroIdentificacionController = TextEditingController();
  final _nombresController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _edadController = TextEditingController();
  final _direccionController = TextEditingController();
  final _barrioController = TextEditingController();
  final _comunaController = TextEditingController();

  bool _aceptoLey = false;
  List<String> _sugerenciasBarrios = [];

  @override
  void initState() {
    super.initState();
    _barrioController.addListener(_buscarBarrio);
  }

  void _buscarBarrio() {
    final texto = _barrioController.text;
    if (texto.length >= 2) {
      setState(() {
        _sugerenciasBarrios = Constantes.obtenerSugerenciasBarrios(texto);
      });
    } else {
      setState(() {
        _sugerenciasBarrios = [];
      });
    }
  }

  void _seleccionarBarrio(String barrio) {
    setState(() {
      _barrioController.text = barrio;
      _sugerenciasBarrios = [];
      
      // Autocompletar comuna
      final comuna = Constantes.encontrarComunaPorBarrio(barrio);
      if (comuna != null) {
        _comunaController.text = comuna;
      }
    });
  }

  @override
  void dispose() {
    _barrioController.removeListener(_buscarBarrio);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Personales'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Autorización Ley 1581
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Autorización Tratamiento de Datos - Ley 1581 de 2012',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(Constantes.primaryColor),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'De conformidad con lo previsto en la Ley 1581 de 2012 "por la cual se dictan las disposiciones generales para la protección de datos personales" y el Decreto 1377 de 2013, al diligenciar este formulario usted otorga la autorización para el manejo de sus datos personales de acuerdo a los lineamientos estipulados por la norma citada. Se presume que la información personal suministrada es veraz y ha sido entregada por el titular de esta y/o su representante o persona autorizada.',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _aceptoLey,
                            onChanged: (value) {
                              setState(() => _aceptoLey = value ?? false);
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Sí, autorizo el tratamiento de mis datos personales',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Formulario datos personales
              SeccionFormulario(
                titulo: 'Información Personal',
                children: [
                  DropdownButtonFormField<String>(
                    value: _tipoIdentificacionController.text.isEmpty 
                        ? null 
                        : _tipoIdentificacionController.text,
                    decoration: InputDecoration(
                      labelText: 'Tipo de Identificación *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: Constantes.tiposIdentificacion.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _tipoIdentificacionController.text = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Seleccione tipo de identificación' : null,
                  ),
                  SizedBox(height: 16),
                  CampoTexto(
                    label: 'Número de Identificación *',
                    controller: _numeroIdentificacionController,
                    validator: (value) => Validadores.validarRequerido(value, 'número de identificación'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  CampoTexto(
                    label: 'Nombres *',
                    controller: _nombresController,
                    validator: (value) => Validadores.validarRequerido(value, 'nombres'),
                  ),
                  SizedBox(height: 16),
                  CampoTexto(
                    label: 'Apellidos *',
                    controller: _apellidosController,
                    validator: (value) => Validadores.validarRequerido(value, 'apellidos'),
                  ),
                  SizedBox(height: 16),
                  CampoTexto(
                    label: 'Edad *',
                    controller: _edadController,
                    validator: Validadores.validarEdad,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 16),
                  CampoTexto(
                    label: 'Dirección de Residencia *',
                    controller: _direccionController,
                    validator: (value) => Validadores.validarRequerido(value, 'dirección'),
                    maxLines: 2,
                  ),
                  SizedBox(height: 16),
                  
                  // Barrio con autocompletado
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _barrioController,
                        decoration: InputDecoration(
                          labelText: 'Barrio *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          suffixIcon: _barrioController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _barrioController.clear();
                                      _comunaController.clear();
                                      _sugerenciasBarrios = [];
                                    });
                                  },
                                )
                              : null,
                        ),
                        validator: (value) => Validadores.validarRequerido(value, 'barrio'),
                      ),
                      
                      // Sugerencias de barrios
                      if (_sugerenciasBarrios.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _sugerenciasBarrios.map((barrio) {
                              return ListTile(
                                title: Text(barrio),
                                onTap: () => _seleccionarBarrio(barrio),
                                dense: true,
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Comuna (autocompletada)
                  TextFormField(
                    controller: _comunaController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Comuna ó Municipio*',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) => Validadores.validarRequerido(value, 'comuna'),
                  ),
                  
                  SizedBox(height: 8),
                  Text(
                    'La comuna se autocompleta al seleccionar el barrio',
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
                      texto: 'Siguiente',
                      onPressed: _aceptoLey ? _siguiente : () { },
                      deshabilitado: !_aceptoLey,
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
      // Validar que la comuna se haya autocompletado
      if (_comunaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor seleccione un barrio válido de la lista'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Crear objeto Estudiante con los datos ingresados
      final estudiante = Estudiante(
        tipoIdentificacion: _tipoIdentificacionController.text,
        numeroIdentificacion: _numeroIdentificacionController.text,
        nombres: _nombresController.text,
        apellidos: _apellidosController.text,
        edad: int.tryParse(_edadController.text) ?? 0,
        direccionResidencia: _direccionController.text,
        barrio: _barrioController.text,
        comuna: _comunaController.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UbicacionContactoPantalla(estudiante: estudiante),
        ),
      );
    }
  }
}