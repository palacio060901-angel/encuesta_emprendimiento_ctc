import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/estudiante.dart';
import '../modelos/contacto.dart';
import '../modelos/programa.dart';
import '../modelos/campos_emprendimiento.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener datos formateados para CSV
  Future<List<Map<String, dynamic>>> getDatosParaCSV() async {
    final snapshot = await _firestore
        .collection('encuestas')
        .orderBy('marcaTemporal', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final estudiante = Estudiante.fromMap(data['datosPersonales']);
      final contacto = Contacto.fromMap(data['contacto']);
      final programa = Programa.fromMap(data['programa']);
      final emprendimiento = CamposEmprendimiento.fromMap(data['camposEmprendimiento']);
      final fecha = data['fechaEnvio'] != null
          ? (data['fechaEnvio'] as Timestamp).toDate()
          : DateTime.now();

      return {
        'id_encuesta': doc.id,
        'fecha_diligenciamiento': _formatearFecha(fecha),
        'nombres': estudiante.nombres,
        'apellidos': estudiante.apellidos,
        'telefono': contacto.telefono,
        'tipo_identificacion': estudiante.tipoIdentificacion,
        'numero_identificacion': estudiante.numeroIdentificacion,
        'edad': estudiante.edad.toString(),
        'direccion_residencia': estudiante.direccionResidencia,
        'barrio': estudiante.barrio,
        'comuna': estudiante.comuna,
        'tiene_sisben': contacto.tieneSisben ? 'Sí' : 'No',
        'puntaje_sisben': contacto.categoriaSisben,
        'estado_vulnerabilidad': contacto.vulnerabilidad,
        'programa_tecnico': programa.programaTecnico,
        'modulo_semestre': programa.moduloSemestre,
        'cursos_cortos_realizados': programa.cursosCortos.join(', '),
        'tiene_idea_negocio': emprendimiento.tieneIdeaNegocio,
        'idea_estructurada_documento': emprendimiento.ideaEstructurada,
        'tiene_empresa_negocio': emprendimiento.tieneEmpresa,
        'empresa_formalizada': emprendimiento.empresaFormalizada.isEmpty
            ? 'No aplica'
            : emprendimiento.empresaFormalizada,
        'direccion_empresa': emprendimiento.direccionEmpresa,
        'cuenta_recursos_financieros': emprendimiento.tieneRecursos,
        'aprender_disenar_ideas': emprendimiento.aprenderDisenar,
        'aprender_estructurar_ideas': emprendimiento.aprenderEstructurar,
        'fortalecer_empresa': emprendimiento.fortalecerEmpresa,
        'sugerencias_centro_tecnologico': emprendimiento.sugerencias,
      };
    }).toList();
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
  }

  // MÉTODO ACTUALIZADO - Generar CSV con formato correcto
  Future<String> generarCSV() async {
    final datos = await getDatosParaCSV();

    if (datos.isEmpty) {
      return '';
    }

    // Encabezados del CSV en español (27 columnas como mencionas)
    final encabezados = [
      'ID_Encuesta',
      'Fecha_Diligenciamiento',
      'Nombres',
      'Apellidos',
      'Telefono',
      'Tipo_Identificacion',
      'Numero_Identificacion',
      'Edad',
      'Direccion_Residencia',
      'Barrio',
      'Comuna',
      'Tiene_SISBEN',
      'Puntaje_SISBEN',
      'Estado_Vulnerabilidad',
      'Programa_Tecnico',
      'Modulo_Semestre',
      'Cursos_Cortos_Realizados',
      'Tiene_Idea_Negocio',
      'Idea_Estructurada_Documento',
      'Tiene_Empresa_Negocio',
      'Empresa_Formalizada',
      'Direccion_Empresa',
      'Cuenta_Recursos_Financieros',
      'Aprender_Disenar_Ideas',
      'Aprender_Estructurar_Ideas',
      'Fortalecer_Empresa',
      'Sugerencias_Centro_Tecnologico'
    ];

    final buffer = StringBuffer();

    // AGREGAR BOM UTF-8 CORRECTAMENTE (para Excel)
    buffer.write('\uFEFF');

    // ESCRIBIR ENCABEZADOS CON COMA (separador estándar)
    buffer.writeln(encabezados.join(','));

    // ESCRIBIR DATOS
    for (final fila in datos) {
      final linea = encabezados.map((encabezado) {
        final clave = _mapearEncabezadoAClave(encabezado);
        final valor = fila[clave]?.toString() ?? '';
        return _escaparCSV(valor);
      }).join(','); // USAR COMA, NO PUNTO Y COMA
      
      buffer.writeln(linea);
    }

    return buffer.toString();
  }

  // Mapear encabezados a claves (actualizado)
  String _mapearEncabezadoAClave(String encabezado) {
    final mapa = {
      'ID_Encuesta': 'id_encuesta',
      'Fecha_Diligenciamiento': 'fecha_diligenciamiento',
      'Nombres': 'nombres',
      'Apellidos': 'apellidos',
      'Telefono': 'telefono',
      'Tipo_Identificacion': 'tipo_identificacion',
      'Numero_Identificacion': 'numero_identificacion',
      'Edad': 'edad',
      'Direccion_Residencia': 'direccion_residencia',
      'Barrio': 'barrio',
      'Comuna': 'comuna',
      'Tiene_SISBEN': 'tiene_sisben',
      'Puntaje_SISBEN': 'puntaje_sisben',
      'Estado_Vulnerabilidad': 'estado_vulnerabilidad',
      'Programa_Tecnico': 'programa_tecnico',
      'Modulo_Semestre': 'modulo_semestre',
      'Cursos_Cortos_Realizados': 'cursos_cortos_realizados',
      'Tiene_Idea_Negocio': 'tiene_idea_negocio',
      'Idea_Estructurada_Documento': 'idea_estructurada_documento',
      'Tiene_Empresa_Negocio': 'tiene_empresa_negocio',
      'Empresa_Formalizada': 'empresa_formalizada',
      'Direccion_Empresa': 'direccion_empresa',
      'Cuenta_Recursos_Financieros': 'cuenta_recursos_financieros',
      'Aprender_Disenar_Ideas': 'aprender_disenar_ideas',
      'Aprender_Estructurar_Ideas': 'aprender_estructurar_ideas',
      'Fortalecer_Empresa': 'fortalecer_empresa',
      'Sugerencias_Centro_Tecnologico': 'sugerencias_centro_tecnologico'
    };
    
    return mapa[encabezado] ?? encabezado.toLowerCase();
  }

  // Escapar caracteres especiales para CSV (actualizado)
  String _escaparCSV(String valor) {
    if (valor.contains(',') || 
        valor.contains('"') || 
        valor.contains('\n') || 
        valor.contains('\r') ||
        valor.contains(';')) {
      // Escapar comillas y envolver en comillas
      return '"${valor.replaceAll('"', '""')}"';
    }
    return valor;
  }

  // MÉTODO ALTERNATIVO - Si aún hay problemas con Excel
  Future<String> generarCSVCompatibilidadMaxima() async {
    final datos = await getDatosParaCSV();

    if (datos.isEmpty) {
      return '';
    }

    final encabezados = [
      'ID_Encuesta',
      'Fecha_Diligenciamiento',
      'Nombres',
      'Apellidos',
      'Telefono',
      'Tipo_Identificacion',
      'Numero_Identificacion',
      'Edad',
      'Direccion_Residencia',
      'Barrio',
      'Comuna',
      'Tiene_SISBEN',
      'Puntaje_SISBEN',
      'Estado_Vulnerabilidad',
      'Programa_Tecnico',
      'Modulo_Semestre',
      'Cursos_Cortos_Realizados',
      'Tiene_Idea_Negocio',
      'Idea_Estructurada_Documento',
      'Tiene_Empresa_Negocio',
      'Empresa_Formalizada',
      'Direccion_Empresa',
      'Cuenta_Recursos_Financieros',
      'Aprender_Disenar_Ideas',
      'Aprender_Estructurar_Ideas',
      'Fortalecer_Empresa',
      'Sugerencias_Centro_Tecnologico'
    ];

    final buffer = StringBuffer();

    // BOM UTF-8 para Excel
    buffer.write('\uFEFF');

    // Encabezados
    buffer.writeln(encabezados.join(','));

    // Datos con manejo robusto de caracteres especiales
    for (final fila in datos) {
      final valores = [];
      
      for (final encabezado in encabezados) {
        final clave = _mapearEncabezadoAClave(encabezado);
        var valor = fila[clave]?.toString() ?? '';
        
        // Limpiar caracteres problemáticos
        valor = valor
            .replaceAll('\n', ' ') // Reemplazar saltos de línea
            .replaceAll('\r', ' ') // Reemplazar retornos de carro
            .replaceAll('"', "'")  // Reemplazar comillas dobles por simples
            .trim();
            
        // Si contiene coma, envolver en comillas
        if (valor.contains(',')) {
          valor = '"$valor"';
        }
        
        valores.add(valor);
      }
      
      buffer.writeln(valores.join(','));
    }

    return buffer.toString();
  }

  // Métodos existentes...
  Future<int?> getTotalEncuestas() async {
    final snapshot = await _firestore.collection('encuestas').count().get();
    return snapshot.count;
  }

  Future<List<Map<String, dynamic>>> getEncuestasPorFecha(DateTime fecha) async {
    final inicio = DateTime(fecha.year, fecha.month, fecha.day);
    final fin = DateTime(fecha.year, fecha.month, fecha.day + 1);

    final snapshot = await _firestore
        .collection('encuestas')
        .where('fechaEnvio', isGreaterThanOrEqualTo: inicio)
        .where('fechaEnvio', isLessThan: fin)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<QuerySnapshot> obtenerEncuestas() {
    return _firestore
        .collection('encuestas')
        .orderBy('marcaTemporal', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>> getEstadisticas() async {
    final totalEncuestas = await getTotalEncuestas();
    final datos = await getDatosParaCSV();
    
    final estudiantesConIdea = datos.where((e) => e['tiene_idea_negocio'] == 'Sí').length;
    final estudiantesConEmpresa = datos.where((e) => e['tiene_empresa_negocio'] == 'Sí').length;
    
    return {
      'total_encuestas': totalEncuestas ?? 0,
      'con_idea_negocio': estudiantesConIdea,
      'con_empresa': estudiantesConEmpresa,
      'ultima_actualizacion': DateTime.now(),
    };
  }
}