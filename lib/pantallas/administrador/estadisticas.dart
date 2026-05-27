import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../servicios/firebase_service.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/constantes.dart';

class EstadisticasPantalla extends StatefulWidget {
  const EstadisticasPantalla({Key? key}) : super(key: key);

  @override
  _EstadisticasPantallaState createState() => _EstadisticasPantallaState();
}

class _EstadisticasPantallaState extends State<EstadisticasPantalla> {
  late Future<Map<String, dynamic>> _estadisticasFuture;

  @override
  void initState() {
    super.initState();
    _estadisticasFuture = _calcularEstadisticas();
  }

  Future<Map<String, dynamic>> _calcularEstadisticas() async {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    final snapshot = await firebaseService.obtenerEncuestas().first;
    
    final encuestas = snapshot.docs;
    final totalEncuestas = encuestas.length;

    if (totalEncuestas == 0) {
      return {'total': 0};
    }

    // Estadísticas básicas
    Map<String, int> programasCount = {};
    Map<String, int> comunasCount = {};
    Map<String, int> emprendimientoCount = {
      'tieneIdea': 0,
      'tieneEmpresa': 0,
      'formalizada': 0,
      'conRecursos': 0,
    };

    for (final doc in encuestas) {
      final datos = doc.data() as Map<String, dynamic>;
      
      // Contar programas
      final programa = datos['programa']['programaTecnico'] ?? '';
      programasCount[programa] = (programasCount[programa] ?? 0) + 1;
      
      // Contar comunas
      final comuna = datos['datosPersonales']['comuna'] ?? '';
      comunasCount[comuna] = (comunasCount[comuna] ?? 0) + 1;
      
      // Contar emprendimiento
      final emprendimiento = datos['camposEmprendimiento'];
      if (emprendimiento['tieneIdeaNegocio'] == 'SI') {
        emprendimientoCount['tieneIdea'] = (emprendimientoCount['tieneIdea'] ?? 0) + 1;
      }
      if (emprendimiento['tieneEmpresa'] == 'SI') {
        emprendimientoCount['tieneEmpresa'] = (emprendimientoCount['tieneEmpresa'] ?? 0) + 1;
      }
      if (emprendimiento['empresaFormalizada'] == 'SI') {
        emprendimientoCount['formalizada'] = (emprendimientoCount['formalizada'] ?? 0) + 1;
      }
      if (emprendimiento['tieneRecursos'] == 'SI') {
        emprendimientoCount['conRecursos'] = (emprendimientoCount['conRecursos'] ?? 0) + 1;
      }
    }

    return {
      'total': totalEncuestas,
      'programas': programasCount,
      'comunas': comunasCount,
      'emprendimiento': emprendimientoCount,
    };
  }

  Widget _tarjetaEstadistica(String titulo, String valor, Color color, IconData icono) {
    return Card(
      color: color,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 30, color: Colors.white),
            SizedBox(height: 12),
            Text(
              valor,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              titulo,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraProgreso(String etiqueta, int valor, int total, Color color) {
    final porcentaje = total > 0 ? (valor / total) * 100 : 0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(etiqueta, style: TextStyle(fontWeight: FontWeight.w500)),
              Text('$valor (${porcentaje.toStringAsFixed(1)}%)'),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: total > 0 ? valor / total : 0,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas'),
        backgroundColor: Color(Constantes.primaryColor),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _estadisticasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return IndicadorCarga(mensaje: 'Calculando estadísticas...');
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stats = snapshot.data!;
          final total = stats['total'] ?? 0;

          if (total == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No hay encuestas para mostrar estadísticas',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las estadísticas aparecerán aquí cuando haya encuestas',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          final programas = stats['programas'] as Map<String, int>;
          final comunas = stats['comunas'] as Map<String, int>;
          final emprendimiento = stats['emprendimiento'] as Map<String, int>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen general
                Text(
                  'Resumen General',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  children: [
                    _tarjetaEstadistica(
                      'Total Encuestas',
                      '$total',
                      Color(Constantes.primaryColor),
                      Icons.assignment,
                    ),
                    _tarjetaEstadistica(
                      'Con Idea Negocio',
                      '${emprendimiento['tieneIdea'] ?? 0}',
                      Colors.green,
                      Icons.lightbulb,
                    ),
                    _tarjetaEstadistica(
                      'Con Empresa',
                      '${emprendimiento['tieneEmpresa'] ?? 0}',
                      Colors.orange,
                      Icons.business,
                    ),
                    _tarjetaEstadistica(
                      'Con Recursos',
                      '${emprendimiento['conRecursos'] ?? 0}',
                      Colors.blue,
                      Icons.attach_money,
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Distribución por programas
                Text(
                  'Programas Técnicos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                ...programas.entries.map((entry) {
                  return _barraProgreso(
                    entry.key,
                    entry.value,
                    total,
                    Color(Constantes.primaryColor),
                  );
                }).toList(),
                
                SizedBox(height: 24),
                
                // Distribución por comunas
                Text(
                  'Distribución por Comunas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                ...comunas.entries.map((entry) {
                  return _barraProgreso(
                    entry.key,
                    entry.value,
                    total,
                    Colors.purple,
                  );
                }).toList(),
                
                SizedBox(height: 24),
                
                // Estadísticas de emprendimiento
                Text(
                  'Indicadores de Emprendimiento',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                
                _barraProgreso(
                  'Estudiantes con idea de negocio',
                  emprendimiento['tieneIdea'] ?? 0,
                  total,
                  Colors.green,
                ),
                _barraProgreso(
                  'Estudiantes con empresa propia',
                  emprendimiento['tieneEmpresa'] ?? 0,
                  total,
                  Colors.orange,
                ),
                if ((emprendimiento['tieneEmpresa'] ?? 0) > 0)
                  _barraProgreso(
                    'Empresas formalizadas',
                    emprendimiento['formalizada'] ?? 0,
                    emprendimiento['tieneEmpresa'] ?? 1,
                    Colors.blue,
                  ),
                _barraProgreso(
                  'Estudiantes con recursos para invertir',
                  emprendimiento['conRecursos'] ?? 0,
                  total,
                  Colors.teal,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}