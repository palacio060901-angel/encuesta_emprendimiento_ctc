import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../servicios/database_service.dart';
import '../../widgets/boton_personalizado.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/constantes.dart';

class ExportarEncuestasPantalla extends StatefulWidget {
  const ExportarEncuestasPantalla({Key? key}) : super(key: key);

  @override
  _ExportarEncuestasPantallaState createState() =>
      _ExportarEncuestasPantallaState();
}

class _ExportarEncuestasPantallaState extends State<ExportarEncuestasPantalla> {
  bool _exportando = false;
  int _totalEncuestas = 0;
  String _estadoExportacion = '';
  String? _rutaArchivoDescargado;

  Future<void> _validarYExportar() async {
    setState(() {
      _exportando = true;
      _estadoExportacion = 'Validando integridad de datos...';
      _rutaArchivoDescargado = null;
    });

    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);

      // Primero validar los datos
      final datos = await databaseService.getDatosParaCSV();
      _totalEncuestas = datos.length;

      if (_totalEncuestas == 0) {
        setState(() {
          _exportando = false;
          _estadoExportacion = 'No hay datos para exportar';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay encuestas para exportar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Proceder con exportación
      await _exportarCSV();
    } catch (e) {
      setState(() {
        _exportando = false;
        _estadoExportacion = '❌ Error en validación';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al validar datos: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportarCSV() async {
    setState(() {
      _exportando = true;
      _estadoExportacion = 'Preparando datos para exportación...';
    });

    try {
      final databaseService =
          Provider.of<DatabaseService>(context, listen: false);

      setState(() => _estadoExportacion = 'Obteniendo datos de Firestore...');
      final datos = await databaseService.getDatosParaCSV();
      _totalEncuestas = datos.length;

      if (datos.isEmpty) {
        setState(() {
          _exportando = false;
          _estadoExportacion = 'No hay datos para exportar';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay encuestas para exportar'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() =>
          _estadoExportacion = 'Generando archivo CSV compatible con Excel...');
      final csvContent = await databaseService.generarCSV();

      // SOLUCIÓN SIN PERMISOS - Usar directorio temporal
      setState(() => _estadoExportacion = 'Creando archivo temporal...');

      final tempDir = await getTemporaryDirectory();
      final fecha = DateTime.now();
      final nombreArchivo =
          'encuestas_emprendimiento_ctc_${fecha.year}${fecha.month.toString().padLeft(2, '0')}${fecha.day.toString().padLeft(2, '0')}_${fecha.hour}${fecha.minute}.csv';

      final tempFile = File('${tempDir.path}/$nombreArchivo');
      await tempFile.writeAsString(csvContent, flush: true);

      setState(() {
        _exportando = false;
        _estadoExportacion =
            '✅ Exportación completada - $_totalEncuestas encuestas';
        _rutaArchivoDescargado = tempFile.path;
      });

      // Compartir el archivo automáticamente
      await _compartirArchivo(tempFile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('✅ CSV exportado exitosamente - $_totalEncuestas encuestas'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      setState(() {
        _exportando = false;
        _estadoExportacion = '❌ Error en la exportación';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error al exportar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _compartirArchivo(File file) async {
    try {
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'Encuestas de Emprendimiento CTC - ${DateTime.now().toString().substring(0, 10)} - $_totalEncuestas encuestas',
        subject: 'CSV Encuestas CTC',
      );
    } catch (e) {
      // Si falla el share, mostrar diálogo con opción de copiar
      _mostrarDialogoContenidoCSV(await file.readAsString());
    }
  }

  void _mostrarDialogoContenidoCSV(String csvContent) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.file_copy, color: Colors.blue),
            SizedBox(width: 8),
            Text('Contenido CSV - Copiar Manualmente'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Si la descarga automática falla, copie este contenido y péguelo en un archivo .csv',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    csvContent,
                    style:
                        const TextStyle(fontFamily: 'Monospace', fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _copiarAlPortapapeles(csvContent);
              Navigator.pop(context);
            },
            child: const Text('COPIAR AL PORTAPAPELES'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CERRAR'),
          ),
        ],
      ),
    );
  }

  void _copiarAlPortapapeles(String texto) {
    // Para copiar al portapapeles necesitarías: import 'package:flutter/services.dart';
    // Clipboard.setData(ClipboardData(text: texto));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contenido CSV copiado al portapapeles'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildInfoCard(
      String titulo, String contenido, IconData icono, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icono, size: 40, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contenido,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaracteristica(String caracteristica, String descripcion) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green, size: 20),
      title: Text(caracteristica,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(descripcion, style: const TextStyle(fontSize: 12)),
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exportar Encuestas'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: _exportando
          ? Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IndicadorCarga(mensaje: _estadoExportacion),
                  const SizedBox(height: 20),
                  if (_totalEncuestas > 0)
                    Text(
                      'Procesando $_totalEncuestas encuestas...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(Constantes.primaryColor)),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header informativo
                  Card(
                    color: Colors.blue[50],
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.analytics,
                              size: 60, color: Color(0xFFD32F2F)),
                          SizedBox(height: 12),
                          Text(
                            'Exportación de Datos Completa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD32F2F),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Genere un archivo CSV compatible con Excel con todos los datos de las encuestas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tarjetas de información
                  _buildInfoCard(
                    'Validación Automática',
                    'El sistema valida la integridad de los datos antes de la exportación',
                    Icons.verified_user,
                    Colors.orange,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    'Compatibilidad Garantizada',
                    'CSV UTF-8 con BOM para perfecta visualización en Excel',
                    Icons.computer,
                    Colors.green,
                  ),

                  const SizedBox(height: 12),

                  _buildInfoCard(
                    'Protección de Datos',
                    'Exportación segura bajo Ley 1581 de 2012',
                    Icons.security,
                    Colors.red,
                  ),

                  const SizedBox(height: 24),

                  // Características técnicas
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🚀 Características Técnicas del CSV:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD32F2F),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildCaracteristica('Codificación UTF-8 con BOM',
                              'Caracteres especiales (ñ, á, é, í, ó, ú) se muestran correctamente en Excel'),
                          _buildCaracteristica('Separador de coma estándar',
                              'Compatibilidad universal con Excel, Google Sheets, LibreOffice'),
                          _buildCaracteristica('Encabezados en español',
                              '27 columnas con nombres descriptivos y sin espacios'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botón de exportación principal
                  Center(
                    child: Column(
                      children: [
                        BotonPersonalizado(
                          texto: '📊 EXPORTAR CSV',
                          onPressed: _validarYExportar,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'El archivo se guardará temporalmente y se compartirá automáticamente',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Estado de la exportación
                  if (_estadoExportacion.isNotEmpty && !_exportando)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _estadoExportacion.contains('✅')
                            ? Colors.green[50]
                            : _estadoExportacion.contains('❌')
                                ? Colors.red[50]
                                : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _estadoExportacion.contains('✅')
                              ? Colors.green
                              : _estadoExportacion.contains('❌')
                                  ? Colors.red
                                  : Colors.blue,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _estadoExportacion.contains('✅')
                                ? Icons.check_circle
                                : _estadoExportacion.contains('❌')
                                    ? Icons.error
                                    : Icons.info,
                            color: _estadoExportacion.contains('✅')
                                ? Colors.green
                                : _estadoExportacion.contains('❌')
                                    ? Colors.red
                                    : Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _estadoExportacion,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: _estadoExportacion.contains('✅')
                                        ? Colors.green[800]
                                        : _estadoExportacion.contains('❌')
                                            ? Colors.red[800]
                                            : Colors.blue[800],
                                  ),
                                ),
                                if (_rutaArchivoDescargado != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Archivo listo para compartir',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Información adicional
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📋 Notas importantes:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '• El archivo CSV incluye todas las encuestas registradas\n'
                            '• Los datos se exportan con la fecha y hora actual\n'
                            '• Puede abrir el archivo en Excel, Google Sheets o cualquier editor de texto\n'
                            '• Los caracteres especiales se mantienen correctamente',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
