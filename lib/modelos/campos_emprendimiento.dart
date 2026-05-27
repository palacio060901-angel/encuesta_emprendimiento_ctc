class CamposEmprendimiento {
  String tieneIdeaNegocio;
  String ideaEstructurada;
  String tieneEmpresa;
  String empresaFormalizada;
  String direccionEmpresa;
  String tieneRecursos;
  String aprenderDisenar;
  String aprenderEstructurar;
  String fortalecerEmpresa;
  String sugerencias;

  CamposEmprendimiento({
    required this.tieneIdeaNegocio,
    required this.ideaEstructurada,
    required this.tieneEmpresa,
    required this.empresaFormalizada,
    required this.direccionEmpresa,
    required this.tieneRecursos,
    required this.aprenderDisenar,
    required this.aprenderEstructurar,
    required this.fortalecerEmpresa,
    required this.sugerencias,
  });

  Map<String, dynamic> toMap() {
    return {
      'tieneIdeaNegocio': tieneIdeaNegocio,
      'ideaEstructurada': ideaEstructurada,
      'tieneEmpresa': tieneEmpresa,
      'empresaFormalizada': empresaFormalizada,
      'direccionEmpresa': direccionEmpresa,
      'tieneRecursos': tieneRecursos,
      'aprenderDisenar': aprenderDisenar,
      'aprenderEstructurar': aprenderEstructurar,
      'fortalecerEmpresa': fortalecerEmpresa,
      'sugerencias': sugerencias,
    };
  }

  static CamposEmprendimiento fromMap(Map<String, dynamic> map) {
    return CamposEmprendimiento(
      tieneIdeaNegocio: map['tieneIdeaNegocio'] ?? '',
      ideaEstructurada: map['ideaEstructurada'] ?? '',
      tieneEmpresa: map['tieneEmpresa'] ?? '',
      empresaFormalizada: map['empresaFormalizada'] ?? '',
      direccionEmpresa: map['direccionEmpresa'] ?? '',
      tieneRecursos: map['tieneRecursos'] ?? '',
      aprenderDisenar: map['aprenderDisenar'] ?? '',
      aprenderEstructurar: map['aprenderEstructurar'] ?? '',
      fortalecerEmpresa: map['fortalecerEmpresa'] ?? '',
      sugerencias: map['sugerencias'] ?? '',
    );
  }

  CamposEmprendimiento copyWith({
    String? tieneIdeaNegocio,
    String? ideaEstructurada,
    String? tieneEmpresa,
    String? empresaFormalizada,
    String? direccionEmpresa,
    String? tieneRecursos,
    String? aprenderDisenar,
    String? aprenderEstructurar,
    String? fortalecerEmpresa,
    String? sugerencias,
  }) {
    return CamposEmprendimiento(
      tieneIdeaNegocio: tieneIdeaNegocio ?? this.tieneIdeaNegocio,
      ideaEstructurada: ideaEstructurada ?? this.ideaEstructurada,
      tieneEmpresa: tieneEmpresa ?? this.tieneEmpresa,
      empresaFormalizada: empresaFormalizada ?? this.empresaFormalizada,
      direccionEmpresa: direccionEmpresa ?? this.direccionEmpresa,
      tieneRecursos: tieneRecursos ?? this.tieneRecursos,
      aprenderDisenar: aprenderDisenar ?? this.aprenderDisenar,
      aprenderEstructurar: aprenderEstructurar ?? this.aprenderEstructurar,
      fortalecerEmpresa: fortalecerEmpresa ?? this.fortalecerEmpresa,
      sugerencias: sugerencias ?? this.sugerencias,
    );
  }
}