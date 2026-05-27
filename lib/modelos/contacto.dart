class Contacto {
  String telefono;
  bool tieneSisben;
  String categoriaSisben;
  String vulnerabilidad;

  Contacto({
    required this.telefono,
    required this.tieneSisben,
    required this.categoriaSisben,
    required this.vulnerabilidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'telefono': telefono,
      'tieneSisben': tieneSisben,
      'categoriaSisben': categoriaSisben,
      'vulnerabilidad': vulnerabilidad,
    };
  }

  static Contacto fromMap(Map<String, dynamic> map) {
    return Contacto(
      telefono: map['telefono'] ?? '',
      tieneSisben: map['tieneSisben'] ?? false,
      categoriaSisben: map['categoriaSisben'] ?? '',
      vulnerabilidad: map['vulnerabilidad'] ?? '',
    );
  }

  Contacto copyWith({
    String? telefono,
    bool? tieneSisben,
    String? categoriaSisben,
    String? vulnerabilidad,
  }) {
    return Contacto(
      telefono: telefono ?? this.telefono,
      tieneSisben: tieneSisben ?? this.tieneSisben,
      categoriaSisben: categoriaSisben ?? this.categoriaSisben,
      vulnerabilidad: vulnerabilidad ?? this.vulnerabilidad,
    );
  }
}