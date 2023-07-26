class TermsAndEmailScreenArguments {
  final String username;

  TermsAndEmailScreenArguments(this.username);
}

class PasswordScreenArguments {
  final String username;
  final String email;

  PasswordScreenArguments(this.username, this.email);
}

class PostScreenArguments {
  final String slug;

  PostScreenArguments(this.slug);
}
