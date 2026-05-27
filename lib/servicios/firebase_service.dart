import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/estudiante.dart';
import '../modelos/contacto.dart';
import '../modelos/programa.dart';
import '../modelos/campos_emprendimiento.dart';
import '../utils/constantes.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Guardar encuesta completa
  Future<void> guardarEncuesta({
    required Estudiante estudiante,
    required Contacto contacto,
    required Programa programa,
    required CamposEmprendimiento emprendimiento,
  }) async {
    try {
      await _firestore.collection(Constantes.encuestasCollection).add({
        'datosPersonales': estudiante.toMap(),
        'contacto': contacto.toMap(),
        'programa': programa.toMap(),
        'camposEmprendimiento': emprendimiento.toMap(),
        'fechaEnvio': FieldValue.serverTimestamp(),
        'marcaTemporal': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      throw Exception('Error al guardar encuesta: $e');
    }
  }

  // Obtener todas las encuestas
  Stream<QuerySnapshot> obtenerEncuestas() {
    return _firestore
        .collection(Constantes.encuestasCollection)
        .orderBy('marcaTemporal', descending: true)
        .snapshots();
  }

  // Obtener encuesta específica
  Future<DocumentSnapshot> obtenerEncuesta(String id) {
    return _firestore.collection(Constantes.encuestasCollection).doc(id).get();
  }
}