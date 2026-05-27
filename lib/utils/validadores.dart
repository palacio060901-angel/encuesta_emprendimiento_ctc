class Validadores {
  static String? validarRequerido(String? value, String campo) {
    if (value == null || value.isEmpty) {
      return 'El campo $campo es requerido';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  static String? validarEdad(String? value) {
    if (value == null || value.isEmpty) {
      return 'La edad es requerida';
    }
    final edad = int.tryParse(value);
    if (edad == null || edad < 1 || edad > 100) {
      return 'La edad debe estar entre 1 y 100 años';
    }
    return null;
  }

  static String? validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es requerido';
    }
    if (value.length < 7) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }
    return null;
  }
}