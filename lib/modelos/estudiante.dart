class Estudiante {
  String tipoIdentificacion;
  String numeroIdentificacion;
  String nombres;
  String apellidos;
  int edad;
  String direccionResidencia;
  String barrio;
  String comuna;

  Estudiante({
    required this.tipoIdentificacion,
    required this.numeroIdentificacion,
    required this.nombres,
    required this.apellidos,
    required this.edad,
    required this.direccionResidencia,
    required this.barrio,
    required this.comuna,
  });

  Map<String, dynamic> toMap() {
    return {
      'tipoIdentificacion': tipoIdentificacion,
      'numeroIdentificacion': numeroIdentificacion,
      'nombres': nombres,
      'apellidos': apellidos,
      'edad': edad,
      'direccionResidencia': direccionResidencia,
      'barrio': barrio,
      'comuna': comuna,
    };
  }

  static Estudiante fromMap(Map<String, dynamic> map) {
    return Estudiante(
      tipoIdentificacion: map['tipoIdentificacion'] ?? '',
      numeroIdentificacion: map['numeroIdentificacion'] ?? '',
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      edad: map['edad'] ?? 0,
      direccionResidencia: map['direccionResidencia'] ?? '',
      barrio: map['barrio'] ?? '',
      comuna: map['comuna'] ?? '',
    );
  }

  Estudiante copyWith({
    String? tipoIdentificacion,
    String? numeroIdentificacion,
    String? nombres,
    String? apellidos,
    int? edad,
    String? direccionResidencia,
    String? barrio,
    String? comuna,
  }) {
    return Estudiante(
      tipoIdentificacion: tipoIdentificacion ?? this.tipoIdentificacion,
      numeroIdentificacion: numeroIdentificacion ?? this.numeroIdentificacion,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      edad: edad ?? this.edad,
      direccionResidencia: direccionResidencia ?? this.direccionResidencia,
      barrio: barrio ?? this.barrio,
      comuna: comuna ?? this.comuna,
    );
  }
}