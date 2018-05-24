
class Validations{
  String validateName(String value) {
    if (value.isEmpty) return 'Nome de usuário é obrigatório.';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Por favor digite apenas caracteres alfanuméricos.';
    return null;
  }

    String validateEmail(String value) {
    if (value.isEmpty) return 'Campo de email é obrigatório.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Endereço de email inválido';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Por favor digite uma senha.';
    return null;
  }

}