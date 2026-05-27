import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../servicios/auth_service.dart';
import '../../widgets/indicador_carga.dart';
import '../../utils/constantes.dart';
import 'ver_encuestas.dart';
import 'estadisticas.dart';
import 'exportar_encuestas.dart';

class PanelPrincipalPantalla extends StatefulWidget {
  const PanelPrincipalPantalla({Key? key}) : super(key: key);

  @override
  _PanelPrincipalPantallaState createState() => _PanelPrincipalPantallaState();
}

class _PanelPrincipalPantallaState extends State<PanelPrincipalPantalla> {
  bool _cerrandoSesion = false;

  Future<void> _cerrarSesion(BuildContext context) async {
    setState(() => _cerrandoSesion = true);
    
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.cerrarSesion();
      
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/', 
        (route) => false
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _cerrandoSesion = false);
    }
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _cerrarSesion(context);
              },
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_cerrandoSesion) {
      return Scaffold(
        body: IndicadorCarga(mensaje: 'Cerrando sesión...'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Administrador'),
        backgroundColor: Color(Constantes.primaryColor),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _mostrarDialogoCerrarSesion(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Bienvenida
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.admin_panel_settings, 
                         size: 40, 
                         color: Color(Constantes.primaryColor)),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenido Administrador',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(Constantes.textColor),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gestiona las encuestas de emprendimiento',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Opciones del panel
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                children: [
                  // Ver Encuestas
                  _buildTarjetaOpcion(
                    Icons.list_alt,
                    'Ver Encuestas',
                    'Consultar todas las encuestas',
                    Color(Constantes.primaryColor),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerEncuestasPantalla()),
                      );
                    },
                  ),

                  // Estadísticas
                  _buildTarjetaOpcion(
                    Icons.bar_chart,
                    'Estadísticas',
                    'Ver gráficos y reportes',
                    Colors.green,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EstadisticasPantalla()),
                      );
                    },
                  ),

                  // Exportar CSV
                  _buildTarjetaOpcion(
                    Icons.file_download,
                    'Exportar CSV',
                    'Descargar datos completos',
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExportarEncuestasPantalla()),
                      );
                    },
                  ),

                  // Cerrar Sesión
                  _buildTarjetaOpcion(
                    Icons.logout,
                    'Cerrar Sesión',
                    'Salir del sistema',
                    Colors.red,
                    () => _mostrarDialogoCerrarSesion(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarjetaOpcion(IconData icono, String titulo, String subtitulo, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 40, color: color),
              SizedBox(height: 12),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color == Colors.red ? color : null,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitulo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}