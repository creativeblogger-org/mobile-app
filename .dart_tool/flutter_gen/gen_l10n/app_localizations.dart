import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('it')
  ];

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Username or email label text
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get username_or_email;

  /// Password label text
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Login text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Invalid username error message
  ///
  /// In en, this message translates to:
  /// **'The username must contain only letters, numbers and underscores, must begin by a letter, contain between 3 and 12 characters.'**
  String get invalid_username;

  /// Password too short error message
  ///
  /// In en, this message translates to:
  /// **'The password must be at least 8 characters long'**
  String get password_too_short;

  /// Invalid email address error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email_address;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Incorrect credentials error message
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get incorrect_credentials;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @do_you_really_want_to_log_out.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to log out ?'**
  String get do_you_really_want_to_log_out;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @internet_error.
  ///
  /// In en, this message translates to:
  /// **'An error occured, please check your Internet connection'**
  String get internet_error;

  /// No description provided for @need_an_account.
  ///
  /// In en, this message translates to:
  /// **'Need an account ?'**
  String get need_an_account;

  /// No description provided for @create_an_account.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get create_an_account;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @not_available.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get not_available;

  /// No description provided for @checking.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// No description provided for @continue_text.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// No description provided for @terms_and_conditions_title.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get terms_and_conditions_title;

  /// No description provided for @terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Please be respectful. You can share your view while respecting others\'.\nKeep also in mind you are the only one responsible of what you post. You can modify or delete your posts which, in that case, will be deleted from the database.\nCreative Blogger Org can\'t be held accountable of any content posted by its members.\nKeep also in mind that, in a legal context, we store your IP address.'**
  String get terms_and_conditions;

  /// No description provided for @accept_and_continue.
  ///
  /// In en, this message translates to:
  /// **'Accept & continue'**
  String get accept_and_continue;

  /// No description provided for @create_a_password.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get create_a_password;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email_address;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get show_more;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @an_error_occured_while_loading_post.
  ///
  /// In en, this message translates to:
  /// **'An error occured while loading post'**
  String get an_error_occured_while_loading_post;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @an_error_occured_while_loading_profile.
  ///
  /// In en, this message translates to:
  /// **'An error occured while loading profile'**
  String get an_error_occured_while_loading_profile;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update_account.
  ///
  /// In en, this message translates to:
  /// **'Update account'**
  String get update_account;

  /// No description provided for @account_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get account_updated_successfully;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password;

  /// No description provided for @delete_my_account.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get delete_my_account;

  /// No description provided for @are_you_sure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure ?'**
  String get are_you_sure;

  /// No description provided for @this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever.
  ///
  /// In en, this message translates to:
  /// **'This is irreversible. All your posts, comments and shorts will be deleted forever.'**
  String get this_is_irreversible_all_your_posts_comments_and_shorts_will_be_deleted_forever;

  /// No description provided for @im_sure.
  ///
  /// In en, this message translates to:
  /// **'I am sure'**
  String get im_sure;

  /// No description provided for @no_post_for_the_moment.
  ///
  /// In en, this message translates to:
  /// **'No post for the moment...'**
  String get no_post_for_the_moment;

  /// No description provided for @no_short_for_the_moment.
  ///
  /// In en, this message translates to:
  /// **'No short for the moment...'**
  String get no_short_for_the_moment;

  /// No description provided for @post_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get post_deleted_successfully;

  /// No description provided for @this_post_will_be_definitely_deleted.
  ///
  /// In en, this message translates to:
  /// **'This post will be definitely deleted'**
  String get this_post_will_be_definitely_deleted;

  /// No description provided for @this_short_will_be_definitely_deleted.
  ///
  /// In en, this message translates to:
  /// **'This short will be definitely deleted'**
  String get this_short_will_be_definitely_deleted;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @an_error_occured_while_loading_user.
  ///
  /// In en, this message translates to:
  /// **'An error occured while loading user'**
  String get an_error_occured_while_loading_user;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @writer.
  ///
  /// In en, this message translates to:
  /// **'Writer'**
  String get writer;

  /// No description provided for @moderator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get moderator;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @signed_up_the.
  ///
  /// In en, this message translates to:
  /// **'Signed up the {date}'**
  String signed_up_the(String date);

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments ({nb})'**
  String comments(int nb);

  /// No description provided for @add_a_comment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment'**
  String get add_a_comment;

  /// No description provided for @this_comment_will_be_definitely_deleted.
  ///
  /// In en, this message translates to:
  /// **'This comment will be definitely deleted'**
  String get this_comment_will_be_definitely_deleted;

  /// No description provided for @no_Internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection'**
  String get no_Internet_connection;

  /// No description provided for @an_error_occured_while_loading_posts.
  ///
  /// In en, this message translates to:
  /// **'An error occured while loading posts'**
  String get an_error_occured_while_loading_posts;

  /// No description provided for @an_error_occured_while_loading_shorts.
  ///
  /// In en, this message translates to:
  /// **'An error occured while loading shorts'**
  String get an_error_occured_while_loading_shorts;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @users_posts.
  ///
  /// In en, this message translates to:
  /// **'User\'s posts :'**
  String get users_posts;

  /// No description provided for @this_user_hasnt_published_any_post_yet.
  ///
  /// In en, this message translates to:
  /// **'This user hasn\'t published any post yet.'**
  String get this_user_hasnt_published_any_post_yet;

  /// No description provided for @search_posts.
  ///
  /// In en, this message translates to:
  /// **'Search posts'**
  String get search_posts;

  /// No description provided for @creative_blogger.
  ///
  /// In en, this message translates to:
  /// **'Creative Blogger'**
  String get creative_blogger;

  /// No description provided for @create_a_post.
  ///
  /// In en, this message translates to:
  /// **'Create a post'**
  String get create_a_post;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @image_url.
  ///
  /// In en, this message translates to:
  /// **'Image URL (104x104) :'**
  String get image_url;

  /// No description provided for @title_too_short.
  ///
  /// In en, this message translates to:
  /// **'Title too short'**
  String get title_too_short;

  /// No description provided for @title_too_long.
  ///
  /// In en, this message translates to:
  /// **'Title too long'**
  String get title_too_long;

  /// No description provided for @invalid_url.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL'**
  String get invalid_url;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @description_too_short.
  ///
  /// In en, this message translates to:
  /// **'Description too short'**
  String get description_too_short;

  /// No description provided for @description_too_long.
  ///
  /// In en, this message translates to:
  /// **'Description too long'**
  String get description_too_long;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @tech.
  ///
  /// In en, this message translates to:
  /// **'Tech'**
  String get tech;

  /// No description provided for @culture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get culture;

  /// No description provided for @investigation.
  ///
  /// In en, this message translates to:
  /// **'Investigation'**
  String get investigation;

  /// No description provided for @publish_post.
  ///
  /// In en, this message translates to:
  /// **'Publish post'**
  String get publish_post;

  /// No description provided for @content_too_short.
  ///
  /// In en, this message translates to:
  /// **'Content too short'**
  String get content_too_short;

  /// No description provided for @content_too_long.
  ///
  /// In en, this message translates to:
  /// **'Content too long'**
  String get content_too_long;

  /// No description provided for @post_published_successfully.
  ///
  /// In en, this message translates to:
  /// **'Post published successfully'**
  String get post_published_successfully;

  /// No description provided for @post_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Post updated successfully'**
  String get post_updated_successfully;

  /// No description provided for @update_post.
  ///
  /// In en, this message translates to:
  /// **'Update post'**
  String get update_post;

  /// No description provided for @comment_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Comment updated successfully'**
  String get comment_updated_successfully;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get edited;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
