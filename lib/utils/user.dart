String getPermission(int permission) {
  switch (permission) {
    case 0:
      return "Membre";
    case 1:
      return "Rédacteur";
    case 2:
      return "Modérateur";
    case 3:
      return "Administrateur";
    default:
      return "Erreur";
  }
}
