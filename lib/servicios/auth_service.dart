import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/administrador.dart';
import '../utils/constantes.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Iniciar sesión como administrador
  Future<Administrador> iniciarSesionAdmin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verificar si es administrador
      DocumentSnapshot adminDoc = await _firestore
          .collection(Constantes.administradoresCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        await _auth.signOut();
        throw Exception('No tienes permisos de administrador');
      }

      return Administrador.fromMap(adminDoc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Verificar si hay sesión activa
  Stream<User?> get usuarioActual => _auth.authStateChanges();

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este correo';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este correo';
      case 'weak-password':
        return 'La contraseña es muy débil';
      default:
        return 'Error de autenticación: $code';
    }
  }
}