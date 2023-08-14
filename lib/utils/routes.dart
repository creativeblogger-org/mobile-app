class TermsAndEmailScreenArguments {
  final String username;
  final DateTime birthdate;

  TermsAndEmailScreenArguments(this.username, this.birthdate);
}

class PasswordScreenArguments {
  final String username;
  final DateTime birthdate;
  final String email;

  PasswordScreenArguments(this.username, this.birthdate, this.email);
}
