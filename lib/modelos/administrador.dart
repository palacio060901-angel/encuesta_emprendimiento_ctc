class Administrador {
  String uid;
  String nombre;
  String correo;
  String rol;

  Administrador({
    required this.uid,
    required this.nombre,
    required this.correo,
    this.rol = 'admin',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
    };
  }

  static Administrador fromMap(Map<String, dynamic> map) {
    return Administrador(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      rol: map['rol'] ?? 'admin',
    );
  }
}