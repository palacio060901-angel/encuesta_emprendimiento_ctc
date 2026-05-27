import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../servicios/firebase_service.dart';
import '../../modelos/estudiante.dart';
import '../../modelos/contacto.dart';
import '../../modelos/programa.dart';
import '../../modelos/campos_emprendimiento.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/constantes.dart';

class VerEncuestasPantalla extends StatelessWidget {
  const VerEncuestasPantalla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Encuestas Enviadas'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.obtenerEncuestas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return IndicadorCarga(mensaje: 'Cargando encuestas...');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No hay encuestas enviadas',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las encuestas aparecerán aquí cuando los estudiantes las envíen',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final encuestas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: encuestas.length,
            itemBuilder: (context, index) {
              final encuesta = encuestas[index];
              final datos = encuesta.data() as Map<String, dynamic>;
              
              final estudiante = Estudiante.fromMap(datos['datosPersonales']);
              final fecha = datos['fechaEnvio'] != null 
                  ? (datos['fechaEnvio'] as Timestamp).toDate()
                  : DateTime.now();

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(Constantes.primaryColor),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    '${estudiante.nombres} ${estudiante.apellidos}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${estudiante.numeroIdentificacion}'),
                      Text(
                        '${fecha.day}/${fecha.month}/${fecha.year} - ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _mostrarDetalleEncuesta(context, datos, fecha);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalleEncuesta(BuildContext context, Map<String, dynamic> datos, DateTime fecha) {
    final estudiante = Estudiante.fromMap(datos['datosPersonales']);
    final contacto = Contacto.fromMap(datos['contacto']);
    final programa = Programa.fromMap(datos['programa']);
    final emprendimiento = CamposEmprendimiento.fromMap(datos['camposEmprendimiento']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.person, color: Color(Constantes.primaryColor)),
            SizedBox(width: 8),
            Text('Detalle de Encuesta'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Información general
              Text(
                '📅 Fecha: ${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Datos Personales
              _buildSeccionDetalle(
                '👤 Datos Personales',
                [
                  'Nombre: ${estudiante.nombres} ${estudiante.apellidos}',
                  'Identificación: ${estudiante.tipoIdentificacion} ${estudiante.numeroIdentificacion}',
                  'Edad: ${estudiante.edad} años',
                  'Dirección: ${estudiante.direccionResidencia}',
                  'Barrio: ${estudiante.barrio}',
                  'Comuna: ${estudiante.comuna}',
                ],
              ),

              SizedBox(height: 16),

              // Contacto
              _buildSeccionDetalle(
                '📞 Contacto',
                [
                  'Teléfono: ${contacto.telefono}',
                  'Sisbén: ${contacto.tieneSisben ? "Sí - Categoría ${contacto.categoriaSisben}" : "No"}',
                  'Vulnerabilidad: ${contacto.vulnerabilidad}',
                ],
              ),

              SizedBox(height: 16),

              // Programa
              _buildSeccionDetalle(
                '🎓 Formación',
                [
                  'Programa: ${programa.programaTecnico}',
                  'Módulo: ${programa.moduloSemestre}',
                  'Cursos: ${programa.cursosCortos.join(", ")}',
                ],
              ),

              SizedBox(height: 16),

              // Emprendimiento
              _buildSeccionDetalle(
                '💡 Emprendimiento',
                [
                  'Idea Negocio: ${emprendimiento.tieneIdeaNegocio}',
                  'Idea Estructurada: ${emprendimiento.ideaEstructurada}',
                  'Empresa Propia: ${emprendimiento.tieneEmpresa}',
                  if (emprendimiento.tieneEmpresa == 'SI') ...[
                    'Empresa Formalizada: ${emprendimiento.empresaFormalizada}',
                    'Dirección Empresa: ${emprendimiento.direccionEmpresa}',
                  ],
                  'Recursos: ${emprendimiento.tieneRecursos}',
                  'Aprender Diseño: ${emprendimiento.aprenderDisenar}',
                  'Aprender Estructura: ${emprendimiento.aprenderEstructurar}',
                  'Fortalecer Empresa: ${emprendimiento.fortalecerEmpresa}',
                  if (emprendimiento.sugerencias.isNotEmpty)
                    'Sugerencias: ${emprendimiento.sugerencias}',
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar', style: TextStyle(color: Color(Constantes.primaryColor))),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionDetalle(String titulo, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(Constantes.primaryColor),
          ),
        ),
        SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Text(
            '• $item',
            style: TextStyle(fontSize: 14),
          ),
        )).toList(),
      ],
    );
  }
}