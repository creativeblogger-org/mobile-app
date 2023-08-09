import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading...';

  @override
  String get welcome_back => 'Welcome back';

  @override
  String get welcome => 'Welcome';

  @override
  String get username_or_email => 'Username or email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get invalid_username => 'The username must contain only letters, numbers and underscores, must begin by a letter, contain between 3 and 12 characters.';

  @override
  String get password_too_short => 'The password must be at least 8 characters long';

  @override
  String get invalid_email_address => 'Invalid email address';

  @override
  String get error => 'Error';

  @override
  String get incorrect_credentials => 'Incorrect credentials';

  @override
  String get ok => 'Ok';

  @override
  String get confirm => 'Confirm';

  @override
  String get do_you_really_want_to_log_out => 'Do you really want to log out ?';

  @override
  String get yes => 'Yes';

  @override
  String get cancel => 'Cancel';

  @override
  String get log_out => 'Log out';

  @override
  String get internet_error => 'An error occured, please check your Internet connection';

  @override
  String get need_an_account => 'Need an account ?';

  @override
  String get create_an_account => 'Create an account';

  @override
  String get username => 'Username';

  @override
  String get available => 'Available';

  @override
  String get not_available => 'Not available';

  @override
  String get checking => 'Checking...';

  @override
  String get continue_text => 'Continue';

  @override
  String get terms_and_conditions_title => 'Terms and conditions';

  @override
  String get terms_and_conditions => 'Please be respectful. You can share your view while respecting others\'.\nKeep also in mind you are the only one responsible of what you post. You can modify or delete your posts which, in that case, will be deleted from the database.\nCreative Blogger Org can\'t be held accountable of any content posted by its members.\nKeep also in mind that, in a legal context, we store your IP address.';

  @override
  String get accept_and_continue => 'Accept & continue';

  @override
  String get create_a_password => 'Create a password';

  @override
  String get email_address => 'Email address';

  @override
  String get show_more => 'Show more';

  @override
  String get post => 'Post';

  @override
  String get an_error_occured_while_loading_post => 'An error occured while loading post';

  @override
  String get profile => 'Profile';

  @override
  String get an_error_occured_while_loading_profile => 'An error occured while loading profile';

  @override
  String get home => 'Home';

  @override
  String get create => 'Create';

  @override
  String get update_account => 'Update account';

  @override
  String get account_updated_successfully => 'Account updated successfully';

  @override
  String get change_password => 'Change password';

  @override
  String get delete_my_account => 'Delete my account';

  @override
  String get are_you_sure => 'Are you sure ?';

  @override
  String get this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever => 'This is irreversible. All your posts, comments and shorts will be deleted forever.';

  @override
  String get im_sure => 'I am sure';

  @override
  String get no_post_for_the_moment => 'No post for the moment...';

  @override
  String get no_short_for_the_moment => 'No short for the moment...';

  @override
  String get post_deleted_successfully => 'Post deleted successfully';

  @override
  String get this_post_will_be_definitely_deleted => 'This post will be definitely deleted';

  @override
  String get this_short_will_be_definitely_deleted => 'This short will be definitely deleted';

  @override
  String get user => 'User';

  @override
  String get an_error_occured_while_loading_user => 'An error occured while loading user';

  @override
  String get member => 'Member';

  @override
  String get writer => 'Writer';

  @override
  String get moderator => 'Moderator';

  @override
  String get administrator => 'Administrator';

  @override
  String signed_up_the(String date) {
    return 'Signed up the $date';
  }

  @override
  String comments(int nb) {
    return 'Comments ($nb)';
  }

  @override
  String get add_a_comment => 'Add a comment';

  @override
  String get this_comment_will_be_definitely_deleted => 'This comment will be definitely deleted';

  @override
  String get no_Internet_connection => 'No Internet connection';

  @override
  String get an_error_occured_while_loading_posts => 'An error occured while loading posts';

  @override
  String get an_error_occured_while_loading_shorts => 'An error occured while loading shorts';

  @override
  String get search => 'Search';

  @override
  String get users_posts => 'User\'s posts :';

  @override
  String get this_user_hasnt_published_any_post_yet => 'This user hasn\'t published any post yet.';

  @override
  String get search_posts => 'Search posts';

  @override
  String get creative_blogger => 'Creative Blogger';

  @override
  String get create_a_post => 'Create a post';

  @override
  String get title => 'Title';

  @override
  String get content => 'Content';

  @override
  String get image_url => 'Image URL (104x104) :';

  @override
  String get title_too_short => 'Title too short';

  @override
  String get title_too_long => 'Title too long';

  @override
  String get invalid_url => 'Invalid URL';

  @override
  String get description => 'Description';

  @override
  String get description_too_short => 'Description too short';

  @override
  String get description_too_long => 'Description too long';

  @override
  String get category => 'Category';

  @override
  String get news => 'News';

  @override
  String get tech => 'Tech';

  @override
  String get culture => 'Culture';

  @override
  String get investigation => 'Investigation';

  @override
  String get publish_post => 'Publish post';

  @override
  String get content_too_short => 'Content too short';

  @override
  String get content_too_long => 'Content too long';

  @override
  String get post_published_successfully => 'Post published successfully';

  @override
  String get post_updated_successfully => 'Post updated successfully';

  @override
  String get update_post => 'Update post';

  @override
  String get comment_updated_successfully => 'Comment updated successfully';

  @override
  String get edited => 'edited';

  @override
  String get all => 'All';
}
