import 'app_localizations.dart';

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get loading => 'Caricamento...';

  @override
  String get welcome_back => 'Bentornato/a';

  @override
  String get welcome => 'Benvenuto/a';

  @override
  String get username_or_email => 'Nome utente o email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Autenticati';

  @override
  String get invalid_username => 'Il nome utente deve contenere solo lettere, numeri e underscore, deve iniziare con una lettera e contenere da 3 a 12 caratteri';

  @override
  String get password_too_short => 'La password deve essere lungo almeno 8 caratteri';

  @override
  String get invalid_email_address => 'Indirizzo email non valido';

  @override
  String get error => 'Errore';

  @override
  String get incorrect_credentials => 'Credenziali non corrette';

  @override
  String get ok => 'Ok';

  @override
  String get confirm => 'Confermare';

  @override
  String get do_you_really_want_to_log_out => 'Sei sicuro che vuoi disconnetterti ?';

  @override
  String get yes => 'Sì';

  @override
  String get cancel => 'Annulla';

  @override
  String get log_out => 'Si disconnettere';

  @override
  String get internet_error => 'Un\'errore si è verificata, controlla la tua connessione Internet.';

  @override
  String get need_an_account => 'Bisogno di un account ?';

  @override
  String get create_an_account => 'Creare un account';

  @override
  String get username => 'Nome utente';

  @override
  String get available => 'Disponibile';

  @override
  String get not_available => 'Non disponibile';

  @override
  String get checking => 'Verifica...';

  @override
  String get continue_text => 'Continua';

  @override
  String get terms_and_conditions_title => 'Termini e Condizioni';

  @override
  String get terms_and_conditions => 'Si prega di essere sempre cortesi. Potete esprimere il vostro parere rispettando quello degli altri.\nRicordate inoltre che siete gli soli responsabili per quello che pubblichiate. Potete modificare o eliminare vostri post che, nel caso, verranno cancellati dal database.\nCreative Blogger Org non può essere ritenuta responsabile per qualsiasi contenuto pubblicato dai suoi membri.\nRicordate anche che, in un quadro giuridico, conserviamo il tuo indirizzo IP.';

  @override
  String get accept_and_continue => 'Accettare & continua';

  @override
  String get create_a_password => 'Crea una password';

  @override
  String get email_address => 'Indirizzo email';

  @override
  String get show_more => 'Mostra di più';

  @override
  String get post => 'Post';

  @override
  String get an_error_occured_while_loading_post => 'Un\'errore si è verificata durante il caricamento del post';

  @override
  String get profile => 'Profilo';

  @override
  String get an_error_occured_while_loading_profile => 'Un\'errore si è verificata durante il caricamento del profilo';

  @override
  String get home => 'Home';

  @override
  String get create => 'Creare';

  @override
  String get update_account => 'Aggiornare l\'account';

  @override
  String get account_updated_successfully => 'Account aggiornato con successo';

  @override
  String get change_password => 'Cambiare la password';

  @override
  String get delete_my_account => 'Elimina il mio account';

  @override
  String get are_you_sure => 'Sei sicuro ?';

  @override
  String get this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever => 'Questo è irreversibile. Tutti i tuoi post, commenti e shorts verranno eliminati per sempre.';

  @override
  String get im_sure => 'Sono sicuro';

  @override
  String get no_post_for_the_moment => 'Nessun post per adesso...';

  @override
  String get no_short_for_the_moment => 'Nessun short per adesso...';

  @override
  String get post_deleted_successfully => 'Post cancellato con successo';

  @override
  String get this_post_will_be_definitely_deleted => 'Questo post sarà cancellato per sempre';

  @override
  String get this_short_will_be_definitely_deleted => 'Questo short sarà cancellato per sempre';

  @override
  String get user => 'Utilizzatore';

  @override
  String get an_error_occured_while_loading_user => 'Un\'errore si è verificata durante il caricamento del utilizzatore';

  @override
  String get member => 'Membro';

  @override
  String get writer => 'Redattore';

  @override
  String get moderator => 'Moderatore';

  @override
  String get administrator => 'Amministratore';

  @override
  String signed_up_the(String date) {
    return 'Iscritto il $date';
  }

  @override
  String comments(int nb) {
    return 'Commenti ($nb)';
  }

  @override
  String get add_a_comment => 'Aggiungi un commento';

  @override
  String get this_comment_will_be_definitely_deleted => 'Questo commento sarà cancellato per sempre';

  @override
  String get no_Internet_connection => 'Nessuna connessione Internet';

  @override
  String get an_error_occured_while_loading_posts => 'Un\'errore si è verificata durante il caricamento dei post';

  @override
  String get an_error_occured_while_loading_shorts => 'Un\'errore si è verificata durante il caricamento dei shorts';

  @override
  String get search => 'Cerca';

  @override
  String get users_posts => 'Posts del utilizzatore :';

  @override
  String get this_user_hasnt_published_any_post_yet => 'Questo utilizzatore non ha ancore pubblicato posts.';

  @override
  String get search_posts => 'Cerca dei posts';

  @override
  String get creative_blogger => 'Creative Blogger';

  @override
  String get create_a_post => 'Creare un post';

  @override
  String get title => 'Titolo';

  @override
  String get content => 'Contenuto';

  @override
  String get image_url => 'URL dell\'immagine (104x104) :';

  @override
  String get title_too_short => 'Titolo troppo corto';

  @override
  String get title_too_long => 'Titolo troppo lungo';

  @override
  String get invalid_url => 'URL non valido';

  @override
  String get description => 'Descrizione';

  @override
  String get description_too_short => 'Descrizione troppo corta';

  @override
  String get description_too_long => 'Descrizione troppo lunga';

  @override
  String get category => 'Categoria';

  @override
  String get news => 'Notizia';

  @override
  String get tech => 'Tech';

  @override
  String get culture => 'Cultura';

  @override
  String get investigation => 'Inchiesta';

  @override
  String get publish_post => 'Pubblica il post';

  @override
  String get content_too_short => 'Contenuto troppo corto';

  @override
  String get content_too_long => 'Contenuto troppo lungo';

  @override
  String get post_published_successfully => 'Post pubblicato con successo';

  @override
  String get post_updated_successfully => 'Post aggiornato con successo';

  @override
  String get update_post => 'Aggiornare il post';

  @override
  String get comment_updated_successfully => 'Commento aggiornato con successo';

  @override
  String get edited => 'modificato';

  @override
  String get all => 'Tutto';
}
