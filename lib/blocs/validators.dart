import 'dart:async';

class Validators {
  final checkUsername = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) async {
    if (username.length > 5) {
      sink.add(username);
    } else {
      sink.addError('Nome de usuário inválido');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Endereço de email inválido');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError('Sua senha deve conter pelo menos 8 caracteres');
    }
  });
}
