class Constantes {
  // Colores
  static const primaryColor = 0xFFD32F2F;
  static const textColor = 0xFF212121;
  static const backgroundColor = 0xFFFFFFFF;

  // Firebase
  static const encuestasCollection = 'encuestas';
  static const administradoresCollection = 'administradores';

  // Opciones para formularios - ACTUALIZADAS
  static final tiposIdentificacion = [
    'RC - Registro civil',
    'TI - Tarjeta de identidad', 
    'CC - Cédula de ciudadanía',
    'TE - Tarjeta de extranjería',
    'CE - Cédula de extranjería',
    'NIT - Número de identificación tributaria',
    'PP - Pasaporte',
    'PEP - Permiso especial de permanencia',
    'DIE - Documento de identificación extranjero'
  ];

  // Mapa de barrios por comuna (para autocompletado)
  static final mapaComunasBarrios = {
    'Comuna 1': [
      'Callejón', 'Centro', 'Contento', 'El Llano', 'La Playa', 'La Sexta', 
      'Latino', 'Páramo'
    ],
    'Comuna 2': [
      'Acuarela', 'Barrio Blanco', 'Bellavista', 'Brisas del Pamplonita', 
      'Los Caobos', 'Ceiba II', 'Colsag', 'Condado de Castilla', 'El Lago', 
      'El Rosal', 'Govika', 'Haricatama', 'Hurapanes', 'La Capillana', 
      'La Castellana', 'La Ceiba', 'La Primavera', 'La Rinconada', 
      'La Riviera', 'Las Almeidas', 'Los Acacios', 'Los Pinos', 
      'Los Próceres', 'Manolo Lemus', 'Mirador Campestre', 'Palma Real', 
      'Parque Central', 'Parque de las Brisas', 'Parque Real', 
      'Parques Residenciales', 'Popular', 'Portal de Prados', 'Prados I', 
      'Prados II', 'Prados Club', 'Quinta Bosch', 'Quinta Oriental', 
      'Quinta Velez', 'Rincón de Prados', 'Santa Clara', 'Santa Lucia', 
      'San Isidro', 'San Remo', 'Torre Real', 'Urb. Galicia', 
      'Urb. La Esperanza', 'Urb. Torre Molinos', 'Valparaíso Suite', 
      'Villas del Prado', 'Villa Real'
    ],
    'Comuna 3': [
      'Las Margaritas Parte Baja', 'Las Margaritas Parte Alta', 
      'La Esmeralda', 'La Unión', 'Boconó', 'Valle Esther', 
      'Aguas Calientes', 'San Mateo', 'La Libertad', 'Santa Ana', 
      'Policarpa', 'Mujeres del Futuro', 'Bogotá', 'Bellavista', 
      'Morelli', 'Santa Clara', 'Nuevo Milenio', 'Brisas del Sinaí', 
      'URB. ARKAMAR CAMPESTRE', 'Villa Silvania', 
      'Portofino Club urbanístico', 
      'Conjunto Cerrado Hacienda San Juan', 
      'Conjunto Residencial Natura', 'Villas De Comfanorte', 
      'La Carolina', 'Caña Fistolo', 'Bethel'
    ],
    'Comuna 4': [
      '13 De Marzo', 'Alto Pamplonita', 'Aniversario I', 'Aniversario ll', 
      'Bajo Pamplonita', 'Bosques Del Pamplonita', 'Cañafistolo', 
      'El Higueron', 'Estacion Del Este', 'Heliopolis', 'La Alameda', 
      'La Campiña', 'La Florida', 'La Isla', 'La Quinta', 
      'Nueva Santa Clara', 'Nuevo Escobal', 'Portal Del Escobal', 
      'Prados Del Este', 'Conjunto Prados Del Este', 'San Jose', 
      'San Luis', 'San Martin I', 'San Martin ll', 'Santa Teresita', 
      'Santillana', 'Terranova', 'Torcoroma', 'Torcoroma Siglo XXl', 
      'Viejo Escobal', 'Villa Camila', 'Villas De San Diego'
    ],
    'Comuna 5': [
      'Alcala', 'Ciudad Jardin', 'Colpet', 'El Bosque', 'Gratamira', 
      'Guaimaral', 'Gualanday', 'Juana Rangel De Cuellar', 'La Mar', 
      'La Maria', 'La Merced', 'Linares', 'Lleras Restrepo', 
      'Los Angeles', 'Niza', 'Paraiso', 'Pescadero', 'Portachuelo', 
      'Prados Del Norte', 'San Eduardo I Y ll', 'Santa Helena', 
      'Sevilla', 'Tasajero', 'Zulima I, l ,lll Y Iv Etapa'
    ],
    'Comuna 6': [
      '20 De Diciembre', '6 De Mayo', '8 De Diciembre', 'Aeropuerto', 
      'Alonsito', 'Brisas Del Aeropuerto', 'Brisas Del Norte', 
      'Brisas Del Paraiso', 'Camilo Daza', 'Caño Limon', 
      'Carlos Garcia Lozada', 'Carlos Pizarro', 'Cecilia Castro', 
      'Cerro De La Cruz', 'Cerro Norte', 'Colinas De La Victoria', 
      'Colinas Del Salado', 'Conj. Cerrado Molinos Del Norte', 
      'Cumbres Del Norte', 'Divino Niño', 'El Cerro', 'El Salado', 
      'Esperanza Martinez', 'Garcia Herreros I Y ll', 'La Concordia', 
      'La Insula', 'Limonar Del Norte', 'Los Laureles', 'Maria Auxiliadora', 
      'Maria Paz', 'Molinos Del Norte', 'Nueva Colombia', 'Olga Teresa', 
      'Panamericano', 'Porvenir', 'Rafael Nuñez', 'San Gerardo', 
      'Simon Bolivar I', 'Toledo Plata', 'Trigal Del Norte', 
      'Urbanizacion Las Americas', 'Villa Juliana', 'Villa Nueva', 
      'Villas Del Tejar', 'Virgilio Barco'
    ],
    'Comuna 7': [
      'Buenos Aires', 'Chapinero', 'Claret', 'Colombia I Y ll', 
      'Comuneros', 'El Paraiso', 'El Rosal Del Norte', 'La Florida', 
      'La Hermita', 'La Laguna', 'La Primavera', 'Las Americas', 
      'Motilones', 'Ospina Perez', 'Tucunare'
    ],
    'Comuna 8': [
      '6 De Enero', '7 De Agosto', 'Antonia Santos', 'Atalaya', 
      'Atalaya I, ll Y lll Etapa', 'Belisario', 'Carlos Ramirez Paris', 
      'Cerro Pico', 'Cucuta 75', 'Doña Nidia', 'El Desierto', 
      'El Minuto De Dios', 'El Progreso', 'El Rodeo', 'Juan Rangel', 
      'La Carolina', 'La Victoria', 'Los Almendros', 'Los Olivos', 
      'Niña Ceci', 'Nuevo Horizonte', 'Palmeras', 'Valles Del Rodeo'
    ],
    'Comuna 9': [
      '8 De Febrero', 'Aislandia', 'Arnulfo Briceño', 'Barrio Nuevo', 
      'Belen', 'Belen De Umbria', 'Carora', 'Cundinamarca', 
      'Divina Pastora', 'El Reposo', 'Fatima', 'Las Colinas', 
      'Loma De Bolivar', 'Los Alpes', 'Pueblo Nuevo', 'Rudesindo Soto', 
      'San Miguel'
    ],
    'Comuna 10': [
      'Alfonso Lopez', 'Camilo Torres', 'Circunvalacion', 'Cuberos Niño', 
      'El Resumen 5 Gaitan', 'Galan', 'La Aurora', 'La Cabrera', 
      'Las Malvinas', 'Magdalena', 'Puente Barco', 'San Jose', 
      'San Rafael', 'Santander', 'Santo Domingo'
    ],
    'Municipio de los Patios': [
      'Altamira', 'Barrio Bonito', 'Bellavista patios', 'Betania', 'Brisas del Llano', 'Cataluña', 'Daniel Jordán', 
      'Minuto de Dios patios', 'Doce de Octubre', 'El Chaparral', 'El Limonar', 'El Mirador', 'El Portal de Los Patios', 
      'El Sol', 'Iscaligua I', 'Iscaligua II', 'Juana Paulav', 'Juana Paula', 'Kilometro Nueve', 'Kilometro Ocho', 
      'La Arboleda', 'La Campiña patios', 'La Cordialidad', 'La Esperanza', 'La Floresta', 'La Sabana', 'Las Cumbres', 'Llanitos', 
      'Llano Grande', 'Los Colorados', 'Miradores del Pamplonita', 'Nazaret', 'Once de Noviembre', 'Patio Antiguo', 'Patios Centro', 
      'Pensilvania', 'Pinar del Rio', 'Pisarreal', 'San Carlos', 'San Fernando', 'San Francisco', 'San Remo patios', 'San Victorino', 'Santa Ana patios', 
      'Santa Clara patios', 'Santa Rosa de Lima', 'Sinai', 'Tasajero patios', 'Tierra Linda', 'Valles del Mirador', 
      'Videlso', 'Villa Betania', 'Villa Camila Patios', 'Villa Celina', 'Villa Esperanza', 'Villa Sonia', 'Villa Verde'
    ],
    'Municipio de Villa del Rosario': [
      'Villa del Rosario', '20 de Julio', 'Antonio Nariño', 'Bellavista Villa del Rosario', 'El Centro', 'El Páramo',
      'Fátima Villa del Rosario', 'Gramalote', 'Gran Colombia', 'La Esperanza Villa del Rosario', 'La Palmita', 'La Parada',
      'Las Pampas', 'Lomitas', 'Montevideo', 'Piedecuesta', 'Primero de Mayo', 'San Gregorio', 'San José Villa del Rosario', 'San Judas Tadeo', 
      'San Martín Villa del Rosario', 'Santa Bárbara', 'Santander Villa del Rosario', 'Sendero de Paz', 'Turbay Ayala', 'Villa Antigua'
    ],
    'Municipio del El Zulia': [
      'El Zulia'
    ]
  };

  // Categorías Sisbén
  static final categoriasSisben = [
    'A1', 'A2', 'A3', 'A4', 'A5',
    'B1', 'B2', 'B3', 'B4', 'B5', 'B6', 'B7',
    'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10', 
    'C11', 'C12', 'C13', 'C14', 'C15', 'C16', 'C17', 'C18',
    'D1', 'D2', 'D3', 'D4', 'D5', 'D6', 'D7', 'D8', 'D9', 'D10',
    'D11', 'D12', 'D13', 'D14', 'D15', 'D16', 'D17', 'D18', 'D19', 'D20'
  ];

  // Vulnerabilidades
  static final vulnerabilidades = [
    'No Aplica',
    'Vulnerabilidad social',
    'Vulnerabilidad económica', 
    'Vulnerabilidad por discapacidad',
    'Vulnerabilidad por desplazamiento forzado',
    'Vulnerabilidad por pertenencia a grupos étnicos',
    'Vulnerabilidad por género o identidad sexual'
  ];

  // Programas técnicos
  static final programasTecnicos = [
    "No Aplica",
    "Técnico ejecutivo de ventas",
    "Técnico laboral desarrollador de aplicaciones informáticas y digitales",
    "Técnico laboral en administración y contabilidad", 
    "Técnico laboral en asesor call center",
    "Técnico laboral ceramista",
    "Técnico Laboral En Construcciones Civiles",
    "Técnico Laboral En Diseño Gráfico",
    "Técnico Laboral En Diseño Web Y Multimedia",
    "Técnico Laboral En Entrenamiento Deportivo",
    "Técnico Laboral En Peluquero Estilista",
    "Técnico Laboral Por Competencias En Atención A La Primera Infancia",
    "Técnico Laboral En Sistemas Integrados De Gestión De Calidad", 
    "Técnico Laboral En Sistemas",
    "Técnico Laboral Zootecnista",
    "Técnico Laboral Patronaje Industrial De Prendas De Vestir",
    "Programa Inglés General"
  ];

  // Módulos/Semestres
  static final modulosSemestre = [
    'Semestre I',
    'Semestre II', 
    'Semestre III',
    'Modulo I',
    'Modulo II',
    'Modulo III',
    'Modulo IIII'
  ];

  // Cursos cortos
  static final cursosCortos = [
    "Convivencia Pacífica Y Prevención Del Consumo Sustancias Psicoactivas",
    "Asesoría de Ventas",
    "Curso de Arduino y robótica", 
    "Curso Corto Marketing Digital",
    "Curso Corto Liderazgo",
    "Curso Corto Software Contable TNS",
    "Curso Corto E-Commerce",
    "Taller - Habilidades Emprendedoras",
    "No Aplica"
  ];

  // Método para encontrar comuna por barrio (insensible a mayúsculas/minúsculas)
  static String? encontrarComunaPorBarrio(String barrioBuscado) {
    final barrioNormalizado = barrioBuscado.trim().toLowerCase();
    
    for (final comuna in mapaComunasBarrios.keys) {
      for (final barrio in mapaComunasBarrios[comuna]!) {
        if (barrio.toLowerCase() == barrioNormalizado) {
          return comuna;
        }
      }
    }
    return null;
  }

  // Método para obtener sugerencias de barrios
  static List<String> obtenerSugerenciasBarrios(String texto) {
    final textoNormalizado = texto.trim().toLowerCase();
    final sugerencias = <String>[];
    
    for (final barrios in mapaComunasBarrios.values) {
      for (final barrio in barrios) {
        if (barrio.toLowerCase().contains(textoNormalizado)) {
          sugerencias.add(barrio);
        }
      }
    }
    return sugerencias.take(5).toList(); // Máximo 5 sugerencias
  }
}