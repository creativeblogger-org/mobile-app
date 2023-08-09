import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get loading => 'Chargement...';

  @override
  String get welcome_back => 'Content de te revoir';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get username_or_email => 'Nom d\'utilisateur ou email';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get invalid_username => 'Le pseudo ne peut contenir que des lettres, des nombres et des underscores, doit commencer par une lettre et contenir entre 3 et 12 caractères compris.';

  @override
  String get password_too_short => 'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get invalid_email_address => 'Adresse email invalide';

  @override
  String get error => 'Erreur';

  @override
  String get incorrect_credentials => 'Identifiants incorrects';

  @override
  String get ok => 'Ok';

  @override
  String get confirm => 'Confirmer';

  @override
  String get do_you_really_want_to_log_out => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get yes => 'Oui';

  @override
  String get cancel => 'Annuler';

  @override
  String get log_out => 'Se déconnecter';

  @override
  String get internet_error => 'Une erreur est survenue, veuillez vérifier votre connexion Internet';

  @override
  String get need_an_account => 'Besoin d\'un compte ?';

  @override
  String get create_an_account => 'Créer un compte';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get available => 'Disponible';

  @override
  String get not_available => 'Indisponible';

  @override
  String get checking => 'Vérification...';

  @override
  String get continue_text => 'Continuer';

  @override
  String get terms_and_conditions_title => 'Termes et conditions';

  @override
  String get terms_and_conditions => 'Veuillez rester cordial dans vos propos. Vous pouvez y exprimer vos opinions tout en respectant celles des autres.\nNous vous rappelons également que vous seul êtes responsable de ce que vous postez. Vous pouvez modifier ou supprimer vos posts qui, dans ce cas, seront supprimés de la base de données.\nCreative Blogger Org ne peut en aucun cas être tenu responsable du contenu posté par ses membres.\nNous vous rappelons également que, dans un cadre juridique, nous stockons votre IP.';

  @override
  String get accept_and_continue => 'Accepter & continuer';

  @override
  String get create_a_password => 'Créer un mot de passe';

  @override
  String get email_address => 'Adresse email';

  @override
  String get show_more => 'Afficher plus';

  @override
  String get post => 'Post';

  @override
  String get an_error_occured_while_loading_post => 'Une erreur s\'est produite lors du chargement du post';

  @override
  String get profile => 'Profil';

  @override
  String get an_error_occured_while_loading_profile => 'Une erreur s\'est produite lors du chargement du profil';

  @override
  String get home => 'Accueil';

  @override
  String get create => 'Créer';

  @override
  String get update_account => 'Mettre à jour le compte';

  @override
  String get account_updated_successfully => 'Compte mis à jour avec succès';

  @override
  String get change_password => 'Changer le mot de passe';

  @override
  String get delete_my_account => 'Supprimer mon compte';

  @override
  String get are_you_sure => 'Êtes-vous sûr ?';

  @override
  String get this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever => 'Cette action est irréversible. Tous vos posts, commentaires et shorts seront supprimés à jamais.';

  @override
  String get im_sure => 'Je suis sûr';

  @override
  String get no_post_for_the_moment => 'Pas de post pour le moment...';

  @override
  String get no_short_for_the_moment => 'Pas de short pour le moment...';

  @override
  String get post_deleted_successfully => 'Post supprimé avec succès';

  @override
  String get this_post_will_be_definitely_deleted => 'Ce post sera définitivement supprimé';

  @override
  String get this_short_will_be_definitely_deleted => 'Ce short sera définitivement supprimé';

  @override
  String get user => 'Utilisateur';

  @override
  String get an_error_occured_while_loading_user => 'Une erreur s\'est produite lors du chargement de l\'utilisateur';

  @override
  String get member => 'Membre';

  @override
  String get writer => 'Rédacteur';

  @override
  String get moderator => 'Moderateur';

  @override
  String get administrator => 'Administrateur';

  @override
  String signed_up_the(String date) {
    return 'Inscrit le $date';
  }

  @override
  String comments(int nb) {
    return 'Commentaires ($nb)';
  }

  @override
  String get add_a_comment => 'Ajoutez un commentaire';

  @override
  String get this_comment_will_be_definitely_deleted => 'Ce commenaire sera définitivement supprimé';

  @override
  String get no_Internet_connection => 'Pas de connexion Internet';

  @override
  String get an_error_occured_while_loading_posts => 'Une erreur s\'est produite lors du chargement des posts';

  @override
  String get an_error_occured_while_loading_shorts => 'Une erreur s\'est produite lors du chargement des shorts';

  @override
  String get search => 'Chercher';

  @override
  String get users_posts => 'Posts de l\'utilisateur :';

  @override
  String get this_user_hasnt_published_any_post_yet => 'Cet utilisateur n\'a pas encore publié de post.';

  @override
  String get search_posts => 'Chercher des posts';

  @override
  String get creative_blogger => 'Creative Blogger';

  @override
  String get create_a_post => 'Créer un post';

  @override
  String get title => 'Titre';

  @override
  String get content => 'Contenu';

  @override
  String get image_url => 'URL de l\'image (104x104) :';

  @override
  String get title_too_short => 'Titre trop court';

  @override
  String get title_too_long => 'Titre trop long';

  @override
  String get invalid_url => 'URL invalide';

  @override
  String get description => 'Description';

  @override
  String get description_too_short => 'Description trop courte';

  @override
  String get description_too_long => 'Description trop longue';

  @override
  String get category => 'Catégorie';

  @override
  String get news => 'Actualité';

  @override
  String get tech => 'Tech';

  @override
  String get culture => 'Culture';

  @override
  String get investigation => 'Enquête';

  @override
  String get publish_post => 'Publier le post';

  @override
  String get content_too_short => 'Contenu trop court';

  @override
  String get content_too_long => 'Contenu trop long';

  @override
  String get post_published_successfully => 'Post publié avec succès';

  @override
  String get post_updated_successfully => 'Post mis à jour avec succès';

  @override
  String get update_post => 'Mettre à jour le post';

  @override
  String get comment_updated_successfully => 'Commentaire mis à jour avec succès';

  @override
  String get edited => 'modifié';

  @override
  String get all => 'Tout';
}
