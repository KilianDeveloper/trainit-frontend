extension EmailValidator on String {
  bool get isValidEmail =>
      isNotEmpty &&
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this);

  bool get isValidPassword => isNotEmpty && length >= 6;
  bool get isValidUsername => isNotEmpty;

  bool get isValidName =>
      isNotEmpty && length <= 50 && !startsWith(" ") && !endsWith(" ");
  bool get isValidUuid => isNotEmpty;
}
