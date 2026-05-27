class Programa {
  String programaTecnico;
  String moduloSemestre;
  List<String> cursosCortos;

  Programa({
    required this.programaTecnico,
    required this.moduloSemestre,
    required this.cursosCortos,
  });

  Map<String, dynamic> toMap() {
    return {
      'programaTecnico': programaTecnico,
      'moduloSemestre': moduloSemestre,
      'cursosCortos': cursosCortos,
    };
  }

  static Programa fromMap(Map<String, dynamic> map) {
    return Programa(
      programaTecnico: map['programaTecnico'] ?? '',
      moduloSemestre: map['moduloSemestre'] ?? '',
      cursosCortos: List<String>.from(map['cursosCortos'] ?? []),
    );
  }

  Programa copyWith({
    String? programaTecnico,
    String? moduloSemestre,
    List<String>? cursosCortos,
  }) {
    return Programa(
      programaTecnico: programaTecnico ?? this.programaTecnico,
      moduloSemestre: moduloSemestre ?? this.moduloSemestre,
      cursosCortos: cursosCortos ?? this.cursosCortos,
    );
  }
}