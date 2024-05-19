import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('en')
  ];

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow:'**
  String get tomorrow;

  /// No description provided for @today_trainings.
  ///
  /// In en, this message translates to:
  /// **'Trainings:'**
  String get today_trainings;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @today_collapsed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today: 0 Trainings} =1{Today: 1 Training} other{Today: {count} Trainings}}'**
  String today_collapsed(num count);

  /// No description provided for @exercise_not_valid.
  ///
  /// In en, this message translates to:
  /// **'Exercise \'{name}\' is not valid'**
  String exercise_not_valid(String name);

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Exercises} =1{1 Exercise} other{{count} Exercises}}'**
  String exercises(num count);

  /// No description provided for @exercises_label.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Exercises: } other{Exercises: {count}}}'**
  String exercises_label(num count);

  /// No description provided for @training_title.
  ///
  /// In en, this message translates to:
  /// **'Training - {name}'**
  String training_title(String name);

  /// No description provided for @trainings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No Trainings} =1{1 Training} other{{count} Trainings}}'**
  String trainings(num count);

  /// No description provided for @minutes_long.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String minutes_long(num count);

  /// No description provided for @minutes_short.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutes_short(num count);

  /// No description provided for @sets_label.
  ///
  /// In en, this message translates to:
  /// **'Sets:'**
  String get sets_label;

  /// No description provided for @rest_day.
  ///
  /// In en, this message translates to:
  /// **'Rest-day'**
  String get rest_day;

  /// No description provided for @calendar_title.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar_title;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @calendar_help_1_title.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get calendar_help_1_title;

  /// No description provided for @calendar_help_1_message.
  ///
  /// In en, this message translates to:
  /// **'The calendar section is to provide you a detailed overview on you upcoming trainings. Your calendar will be automatically generated by your training plan.'**
  String get calendar_help_1_message;

  /// No description provided for @calendar_help_2_title.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get calendar_help_2_title;

  /// No description provided for @calendar_help_2_message.
  ///
  /// In en, this message translates to:
  /// **'All of your trainings for the upcoming week will be shown to you. As summary, you can see the name, number of exercises and the calculated time you will probably need to complete the training.'**
  String get calendar_help_2_message;

  /// No description provided for @calendar_help_3_title.
  ///
  /// In en, this message translates to:
  /// **'Detailed information'**
  String get calendar_help_3_title;

  /// No description provided for @calendar_help_3_message.
  ///
  /// In en, this message translates to:
  /// **'You can see a detailed version of your training by clicking on it.'**
  String get calendar_help_3_message;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{today} =1{1 day ago} other{{count} days ago}}'**
  String days_ago(num count);

  /// No description provided for @pounds.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get pounds;

  /// No description provided for @kilograms.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kilograms;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get seconds;

  /// No description provided for @meters.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meters;

  /// No description provided for @centimeters.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get centimeters;

  /// No description provided for @statistics_title.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics_title;

  /// No description provided for @your_personal_records_label.
  ///
  /// In en, this message translates to:
  /// **'Personal Records:'**
  String get your_personal_records_label;

  /// No description provided for @your_goals_label.
  ///
  /// In en, this message translates to:
  /// **'Goals:'**
  String get your_goals_label;

  /// No description provided for @personal_record_label.
  ///
  /// In en, this message translates to:
  /// **'Personal Record:'**
  String get personal_record_label;

  /// No description provided for @value_name_label.
  ///
  /// In en, this message translates to:
  /// **'Value Name:'**
  String get value_name_label;

  /// No description provided for @personal_record.
  ///
  /// In en, this message translates to:
  /// **'Personal Record'**
  String get personal_record;

  /// No description provided for @body_value.
  ///
  /// In en, this message translates to:
  /// **'Body Value'**
  String get body_value;

  /// No description provided for @body_weight.
  ///
  /// In en, this message translates to:
  /// **'Body Weight'**
  String get body_weight;

  /// No description provided for @body_fat.
  ///
  /// In en, this message translates to:
  /// **'Body Fat'**
  String get body_fat;

  /// No description provided for @create_goal_title.
  ///
  /// In en, this message translates to:
  /// **'Create Goal'**
  String get create_goal_title;

  /// No description provided for @edit_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Record'**
  String get edit_personal_record_title;

  /// No description provided for @create_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Create Personal Record'**
  String get create_personal_record_title;

  /// No description provided for @name_label.
  ///
  /// In en, this message translates to:
  /// **'Name:'**
  String get name_label;

  /// No description provided for @type_label.
  ///
  /// In en, this message translates to:
  /// **'Type:'**
  String get type_label;

  /// No description provided for @value_label.
  ///
  /// In en, this message translates to:
  /// **'Value:'**
  String get value_label;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @name_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get name_placeholder;

  /// No description provided for @empty_personal_records_title.
  ///
  /// In en, this message translates to:
  /// **'Nothing to see in here.'**
  String get empty_personal_records_title;

  /// No description provided for @empty_personal_records_message.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a new Personal Record to trace your progress.'**
  String get empty_personal_records_message;

  /// No description provided for @delete_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Personal Record.'**
  String get delete_personal_record_title;

  /// No description provided for @delete_personal_record_message.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete your Personal Record {name}. The removal cannot be reverted.'**
  String delete_personal_record_message(String name);

  /// No description provided for @superset.
  ///
  /// In en, this message translates to:
  /// **'Superset'**
  String get superset;

  /// No description provided for @delete_superset.
  ///
  /// In en, this message translates to:
  /// **'Unlink Superset'**
  String get delete_superset;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @enter_name.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get enter_name;

  /// No description provided for @enter_text.
  ///
  /// In en, this message translates to:
  /// **'Value cannot be empty'**
  String get enter_text;

  /// No description provided for @value_between.
  ///
  /// In en, this message translates to:
  /// **'Value must be between {from} and {to}'**
  String value_between(num from, num to);

  /// No description provided for @statistics_help_1_title.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get statistics_help_1_title;

  /// No description provided for @statistics_help_1_message.
  ///
  /// In en, this message translates to:
  /// **'Here, you can manage your personal records, you hit over the time.'**
  String get statistics_help_1_message;

  /// No description provided for @statistics_help_2_title.
  ///
  /// In en, this message translates to:
  /// **'Creating a new personal record'**
  String get statistics_help_2_title;

  /// No description provided for @statistics_help_2_message.
  ///
  /// In en, this message translates to:
  /// **'To create a new personal record category just click the +-button in the bottom-right corner of the page, provide a name and the weight you liftet and click on \'Save\'.'**
  String get statistics_help_2_message;

  /// No description provided for @statistics_help_3_title.
  ///
  /// In en, this message translates to:
  /// **'Editing Personal Records'**
  String get statistics_help_3_title;

  /// No description provided for @statistics_help_3_message.
  ///
  /// In en, this message translates to:
  /// **'By clicking on your personal record and selecting \'Update\', you can edit your personal record and add a new weight to it.'**
  String get statistics_help_3_message;

  /// No description provided for @defaults_label.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get defaults_label;

  /// No description provided for @weightunit_label.
  ///
  /// In en, this message translates to:
  /// **'Weight Unit'**
  String get weightunit_label;

  /// No description provided for @set_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Set duration'**
  String get set_duration_label;

  /// No description provided for @set_rest_duration_label.
  ///
  /// In en, this message translates to:
  /// **'Rest duration'**
  String get set_rest_duration_label;

  /// No description provided for @training_plan_label.
  ///
  /// In en, this message translates to:
  /// **'Training Plan'**
  String get training_plan_label;

  /// No description provided for @friends_label.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends_label;

  /// No description provided for @all_friends_label.
  ///
  /// In en, this message translates to:
  /// **'All friends'**
  String get all_friends_label;

  /// No description provided for @notification_friends_label.
  ///
  /// In en, this message translates to:
  /// **'New Notifications'**
  String get notification_friends_label;

  /// No description provided for @requested_friends_label.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requested_friends_label;

  /// No description provided for @added_friends_label.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added_friends_label;

  /// No description provided for @add_friends.
  ///
  /// In en, this message translates to:
  /// **'Add friends'**
  String get add_friends;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @no_friends.
  ///
  /// In en, this message translates to:
  /// **'You don’t have any friends added.'**
  String get no_friends;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @lets_fix_friends.
  ///
  /// In en, this message translates to:
  /// **'Let\'s fix that'**
  String get lets_fix_friends;

  /// No description provided for @view_friends.
  ///
  /// In en, this message translates to:
  /// **'View friends'**
  String get view_friends;

  /// No description provided for @friends_title.
  ///
  /// In en, this message translates to:
  /// **'Your friends'**
  String get friends_title;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @featured_personal_records.
  ///
  /// In en, this message translates to:
  /// **'Featured Personal Records'**
  String get featured_personal_records;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend} other{{count} friends}}'**
  String friends(num count);

  /// No description provided for @follower_number.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Follower} other{{count} Followers}}'**
  String follower_number(num count);

  /// No description provided for @following_number.
  ///
  /// In en, this message translates to:
  /// **'{count} Following'**
  String following_number(num count);

  /// No description provided for @follower_text.
  ///
  /// In en, this message translates to:
  /// **'Follower since {count, plural, =0{today} =1{yesterday} other{{count} days}}'**
  String follower_text(num count);

  /// No description provided for @following_text.
  ///
  /// In en, this message translates to:
  /// **'Following since {count, plural, =0{today} =1{yesterday} other{{count} days}}'**
  String following_text(num count);

  /// No description provided for @account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_title;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @design_label.
  ///
  /// In en, this message translates to:
  /// **'Design:'**
  String get design_label;

  /// No description provided for @theme_label.
  ///
  /// In en, this message translates to:
  /// **'App Theme:'**
  String get theme_label;

  /// No description provided for @theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get theme_light;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get theme_system;

  /// No description provided for @documents_label.
  ///
  /// In en, this message translates to:
  /// **'Documents:'**
  String get documents_label;

  /// No description provided for @terms_label.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_label;

  /// No description provided for @privacy_label.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_label;

  /// No description provided for @view_browser.
  ///
  /// In en, this message translates to:
  /// **'View in browser'**
  String get view_browser;

  /// No description provided for @contact_label.
  ///
  /// In en, this message translates to:
  /// **'Contact:'**
  String get contact_label;

  /// No description provided for @email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email_label;

  /// No description provided for @account_label.
  ///
  /// In en, this message translates to:
  /// **'Account:'**
  String get account_label;

  /// No description provided for @username_label.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username_label;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @about_label.
  ///
  /// In en, this message translates to:
  /// **'About:'**
  String get about_label;

  /// No description provided for @version_label.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version_label;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @days_label.
  ///
  /// In en, this message translates to:
  /// **'Trainings:'**
  String get days_label;

  /// No description provided for @add_new.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get add_new;

  /// No description provided for @add_new_exercise.
  ///
  /// In en, this message translates to:
  /// **'Add new Exercise'**
  String get add_new_exercise;

  /// No description provided for @number_sets_label.
  ///
  /// In en, this message translates to:
  /// **'Number of Sets: {count}'**
  String number_sets_label(num count);

  /// No description provided for @number_sets_short.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Sets} =1{1 Set} other{{count} Sets}}'**
  String number_sets_short(num count);

  /// No description provided for @set_label.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Dropset} other{Set: {count}}}'**
  String set_label(num count);

  /// No description provided for @dropset.
  ///
  /// In en, this message translates to:
  /// **'Dropset'**
  String get dropset;

  /// No description provided for @create_goal_text.
  ///
  /// In en, this message translates to:
  /// **'Create your first goal to get started'**
  String get create_goal_text;

  /// No description provided for @get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get get_started;

  /// No description provided for @enter_integer.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid integer'**
  String get enter_integer;

  /// No description provided for @enter_above_zero.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number above 0'**
  String get enter_above_zero;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get unknown;

  /// No description provided for @sign_out_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to sign out?'**
  String get sign_out_confirmation_message;

  /// No description provided for @edit_profile_photo_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Photo'**
  String get edit_profile_photo_title;

  /// No description provided for @delete_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile Photo'**
  String get delete_profile_photo;

  /// No description provided for @add_profile_photo.
  ///
  /// In en, this message translates to:
  /// **'Add new Profile Photo'**
  String get add_profile_photo;

  /// No description provided for @edit_training_plan_help_1_title.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get edit_training_plan_help_1_title;

  /// No description provided for @edit_training_plan_help_1_message.
  ///
  /// In en, this message translates to:
  /// **'You can change the name of your training plan: For example you can name it same as your training routine(e.g. \'push pull legs\').'**
  String get edit_training_plan_help_1_message;

  /// No description provided for @edit_training_plan_help_2_title.
  ///
  /// In en, this message translates to:
  /// **'Creating new trainings'**
  String get edit_training_plan_help_2_title;

  /// No description provided for @edit_training_plan_help_2_message.
  ///
  /// In en, this message translates to:
  /// **'To create a new training in your training plan, you can use the \'Add new\' button next to the days name.'**
  String get edit_training_plan_help_2_message;

  /// No description provided for @edit_training_plan_help_3_title.
  ///
  /// In en, this message translates to:
  /// **'Editing trainings'**
  String get edit_training_plan_help_3_title;

  /// No description provided for @edit_training_plan_help_3_message.
  ///
  /// In en, this message translates to:
  /// **'By clicking \'Edit\' on a training, you can edit its structure, add/remove exercises or rename the training.'**
  String get edit_training_plan_help_3_message;

  /// No description provided for @edit_training_plan_help_4_title.
  ///
  /// In en, this message translates to:
  /// **'Moving trainings'**
  String get edit_training_plan_help_4_title;

  /// No description provided for @edit_training_plan_help_4_message.
  ///
  /// In en, this message translates to:
  /// **'By dragging and dropping it on the correct day, you can move your training between the days of the week.'**
  String get edit_training_plan_help_4_message;

  /// No description provided for @edit_training_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Training'**
  String get edit_training_title;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @edit_training_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Training Plan'**
  String get edit_training_plan_title;

  /// No description provided for @enter_email.
  ///
  /// In en, this message translates to:
  /// **'Enter your Email'**
  String get enter_email;

  /// No description provided for @enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Email'**
  String get enter_valid_email;

  /// No description provided for @check_inbox.
  ///
  /// In en, this message translates to:
  /// **'Check your inbox'**
  String get check_inbox;

  /// No description provided for @check_verification.
  ///
  /// In en, this message translates to:
  /// **'Check Verification'**
  String get check_verification;

  /// No description provided for @send_again.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get send_again;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'Password:'**
  String get password_label;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @percent.
  ///
  /// In en, this message translates to:
  /// **'%'**
  String get percent;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @started_at.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String started_at(String date);

  /// No description provided for @private_profile.
  ///
  /// In en, this message translates to:
  /// **'Private Profile'**
  String get private_profile;

  /// No description provided for @empty_training_plan.
  ///
  /// In en, this message translates to:
  /// **'Empty Training Plan'**
  String get empty_training_plan;

  /// No description provided for @profile_not_found.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profile_not_found;

  /// No description provided for @training_not_found.
  ///
  /// In en, this message translates to:
  /// **'Training not found'**
  String get training_not_found;

  /// No description provided for @decrease_value.
  ///
  /// In en, this message translates to:
  /// **'Drop {name}'**
  String decrease_value(String name);

  /// No description provided for @loading_title.
  ///
  /// In en, this message translates to:
  /// **'Loading {name}...'**
  String loading_title(String name);

  /// No description provided for @friends_status_requested_me.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get friends_status_requested_me;

  /// No description provided for @friends_status_requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get friends_status_requested;

  /// No description provided for @friends_status_none.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get friends_status_none;

  /// No description provided for @friends_status_full.
  ///
  /// In en, this message translates to:
  /// **'Followed'**
  String get friends_status_full;

  /// No description provided for @increase_value.
  ///
  /// In en, this message translates to:
  /// **'Increase {name}'**
  String increase_value(String name);

  /// No description provided for @go_to_register.
  ///
  /// In en, this message translates to:
  /// **'No Account? Create a new one.'**
  String get go_to_register;

  /// No description provided for @enter_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your Password'**
  String get enter_password;

  /// No description provided for @password_requirements.
  ///
  /// In en, this message translates to:
  /// **'Passwords cannot be empty and should be at least 6 characters long.'**
  String get password_requirements;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @enter_username.
  ///
  /// In en, this message translates to:
  /// **'Enter your Username'**
  String get enter_username;

  /// No description provided for @username_requirements.
  ///
  /// In en, this message translates to:
  /// **'Usernames cannot be empty'**
  String get username_requirements;

  /// No description provided for @email_verification_title.
  ///
  /// In en, this message translates to:
  /// **'Email not Verified'**
  String get email_verification_title;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @register_title.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_title;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @invalid_input_title.
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalid_input_title;

  /// No description provided for @invalid_input_message.
  ///
  /// In en, this message translates to:
  /// **'Your inputs are invalid. Please edit them and try again.'**
  String get invalid_input_message;

  /// No description provided for @unsaved_title.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsaved_title;

  /// No description provided for @unsaved_message.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved Changes. Do you want to save them?'**
  String get unsaved_message;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @delete_exercise_confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Exercise'**
  String get delete_exercise_confirmation_title;

  /// No description provided for @delete_exercise_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the Exercise {name}'**
  String delete_exercise_confirmation_message(String name);

  /// No description provided for @delete_training_confirmation_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Training'**
  String get delete_training_confirmation_title;

  /// No description provided for @delete_training_confirmation_message.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the Training {name} from your Training Plan'**
  String delete_training_confirmation_message(String name);

  /// No description provided for @login_title_label.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get login_title_label;

  /// No description provided for @register_title_label.
  ///
  /// In en, this message translates to:
  /// **'Create an account to access the app'**
  String get register_title_label;

  /// No description provided for @tutorial_welcome_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get tutorial_welcome_title;

  /// No description provided for @tutorial_welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to KeyPlan - your personal training planner. Let us introduce you to the app by giving you a short overview on the app!'**
  String get tutorial_welcome_message;

  /// No description provided for @tutorial_calendar_title.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tutorial_calendar_title;

  /// No description provided for @tutorial_calendar_message.
  ///
  /// In en, this message translates to:
  /// **'The tutorial starts here. This is also the opening point of the App. It is your training calendar. All your future trainings for the next seven days will be viewed here. Your calendar currently looks pretty empty. Let\'s fix that by editing your training plan!'**
  String get tutorial_calendar_message;

  /// No description provided for @tutorial_navigation_title.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get tutorial_navigation_title;

  /// No description provided for @tutorial_navigation_message.
  ///
  /// In en, this message translates to:
  /// **'On the bottom of the app, you can find the main navigation menu. Here, you can navigate between the main components of the app. You can edit your training plan in your accounts settings. To go there, select the \'Account\'-Tab'**
  String get tutorial_navigation_message;

  /// No description provided for @tutorial_account_title.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get tutorial_account_title;

  /// No description provided for @tutorial_account_message.
  ///
  /// In en, this message translates to:
  /// **'This is your account page. Here you can change your main account settings as your preferred set-rest duration etc. On the top, you can access the app settings. To get started with the app, you need to provide your personal training plan. To do so, scroll down to the section \'Training Plan\' and click on \'Edit\'.'**
  String get tutorial_account_message;

  /// No description provided for @tutorial_training_plan_edit_page_title.
  ///
  /// In en, this message translates to:
  /// **'Editing Training Plans'**
  String get tutorial_training_plan_edit_page_title;

  /// No description provided for @tutorial_training_plan_edit_page_message.
  ///
  /// In en, this message translates to:
  /// **'Now, the edit page of your training plan will be viewed. Your training plan provides information about how you train. You will provide your trainings for a specific day of the week and the training plan will put these trainings in the desired day of your calendar. For example, you can do a Push/Pull/Legs split and add Push to monday, Pull to wednesday and Legs to friday. Also, you can set your training plan\'s name.'**
  String get tutorial_training_plan_edit_page_message;

  /// No description provided for @tutorial_training_plan_create_training_title.
  ///
  /// In en, this message translates to:
  /// **'Creating Trainings'**
  String get tutorial_training_plan_create_training_title;

  /// No description provided for @tutorial_training_plan_create_training_message.
  ///
  /// In en, this message translates to:
  /// **'Let\'s test this by creating a new training. To do so, click on the \'Add\'-button for the training section and select a day to add the training to.'**
  String get tutorial_training_plan_create_training_message;

  /// No description provided for @tutorial_training_plan_click_training_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Trainings'**
  String get tutorial_training_plan_click_training_title;

  /// No description provided for @tutorial_training_plan_click_training_message.
  ///
  /// In en, this message translates to:
  /// **'Now, you see your training on the day, you added it to. To configure it, just click on it.'**
  String get tutorial_training_plan_click_training_message;

  /// No description provided for @tutorial_training_plan_overview_title.
  ///
  /// In en, this message translates to:
  /// **'Trainings'**
  String get tutorial_training_plan_overview_title;

  /// No description provided for @tutorial_training_plan_overview_message.
  ///
  /// In en, this message translates to:
  /// **'The edit page of trainings works similar to the of the training plan. Trainings are part of a training plan and contain information about how a specific training will work. You can add exercises to it to do so. You can also edit the name of your trainings.'**
  String get tutorial_training_plan_overview_message;

  /// No description provided for @tutorial_add_exercise_title.
  ///
  /// In en, this message translates to:
  /// **'Adding Exercises'**
  String get tutorial_add_exercise_title;

  /// No description provided for @tutorial_add_exercise_message.
  ///
  /// In en, this message translates to:
  /// **'To add a new exercise, click on the \'Add\'-button of the exercises section. You can now expand the exercise and add a specific number of sets to it. Every set can have a unique amount of repetitions. Try it out and add a few exercises before continuing!'**
  String get tutorial_add_exercise_message;

  /// No description provided for @tutorial_save_training_and_plan_title.
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get tutorial_save_training_and_plan_title;

  /// No description provided for @tutorial_save_training_and_plan_message.
  ///
  /// In en, this message translates to:
  /// **'Now, after your training is fully configured, you can save. Be careful to always save your progress, your configuration won\'t be saved automatically to prevent unintentionally override of your training plan. On the bottom-right corner, you will see a button to save your training plan. Now, save your work!'**
  String get tutorial_save_training_and_plan_message;

  /// No description provided for @tutorial_navigate_calendar_title.
  ///
  /// In en, this message translates to:
  /// **'Back to Calendar'**
  String get tutorial_navigate_calendar_title;

  /// No description provided for @tutorial_navigate_calendar_message.
  ///
  /// In en, this message translates to:
  /// **'You now created your personal training plan. Let\'s go back to your calendar by navigating to the \'Home\'-Tab'**
  String get tutorial_navigate_calendar_message;

  /// No description provided for @tutorial_click_calendar_training_title.
  ///
  /// In en, this message translates to:
  /// **'Your Calendar'**
  String get tutorial_click_calendar_training_title;

  /// No description provided for @tutorial_click_calendar_training_message.
  ///
  /// In en, this message translates to:
  /// **'After you edited your training plan, click on the refresh-button of your calendar, to sync your training plan with the calendar. The app will then insert your trainings into your calendar by inserting it into the day of the week, you selected. To get an overview on your training, just click on it!'**
  String get tutorial_click_calendar_training_message;

  /// No description provided for @tutorial_calendar_training_title.
  ///
  /// In en, this message translates to:
  /// **'Training Preview'**
  String get tutorial_calendar_training_title;

  /// No description provided for @tutorial_calendar_training_message.
  ///
  /// In en, this message translates to:
  /// **'This is the preview of a training. It will show you all the information as the duration of the training and it\'s exercises, so you can focus on your training.'**
  String get tutorial_calendar_training_message;

  /// No description provided for @tutorial_navigate_statistics_title.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get tutorial_navigate_statistics_title;

  /// No description provided for @tutorial_navigate_statistics_message.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start the final section of the tutorial. To do so, click on the \'Statistics\'-tab'**
  String get tutorial_navigate_statistics_message;

  /// No description provided for @tutorial_statistics_overview_title.
  ///
  /// In en, this message translates to:
  /// **'Your Statistics'**
  String get tutorial_statistics_overview_title;

  /// No description provided for @tutorial_statistics_overview_message.
  ///
  /// In en, this message translates to:
  /// **'Here you can find your personal statistics. You can add your personal bests (aka. your personal records or PR\'s) to your statistics to never ever forgot your personal records and to easily track them.'**
  String get tutorial_statistics_overview_message;

  /// No description provided for @tutorial_click_new_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Adding a new Personal Record'**
  String get tutorial_click_new_personal_record_title;

  /// No description provided for @tutorial_click_new_personal_record_message.
  ///
  /// In en, this message translates to:
  /// **'To insert a new personal record, you can just click on the \'Add\'-button on the bottom-right.'**
  String get tutorial_click_new_personal_record_message;

  /// No description provided for @tutorial_create_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Adding a new Personal Record'**
  String get tutorial_create_personal_record_title;

  /// No description provided for @tutorial_create_personal_record_message.
  ///
  /// In en, this message translates to:
  /// **'A new page will pop up where you can configure your new personal record. You can differentiate between different types of personal records. Those are record-weights, record-lengths and record-times. You can also switch the unit of your personal record by clicking on the current unit. Now, insert the name of your personal record (e.g. \'Bench Press\'), enter the values and save it.'**
  String get tutorial_create_personal_record_message;

  /// No description provided for @tutorial_edit_personal_record_title.
  ///
  /// In en, this message translates to:
  /// **'Editing Personal Records'**
  String get tutorial_edit_personal_record_title;

  /// No description provided for @tutorial_edit_personal_record_message.
  ///
  /// In en, this message translates to:
  /// **'Your personal record will now appear in your list. To edit or delete a personal record, just click on it!'**
  String get tutorial_edit_personal_record_message;

  /// No description provided for @tutorial_end_title.
  ///
  /// In en, this message translates to:
  /// **'Tutorial Finished'**
  String get tutorial_end_title;

  /// No description provided for @tutorial_end_message.
  ///
  /// In en, this message translates to:
  /// **'One last thing: If you have any questions, you can find on some points of the app on the top a question-mark, which explains features again to you if you forget. And that\'s it! You now have a basic understanding of the App and can enjoy your Fitness-Journey with Keyplan - Workout Planner. Have fun ;)'**
  String get tutorial_end_message;

  /// No description provided for @skip_tutorial.
  ///
  /// In en, this message translates to:
  /// **'Skip Tutorial'**
  String get skip_tutorial;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @click_to_skip.
  ///
  /// In en, this message translates to:
  /// **'Tap to view next step'**
  String get click_to_skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next step'**
  String get next;

  /// No description provided for @error_no_connection.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Synching failed'**
  String get error_no_connection;

  /// No description provided for @error_authentication_internal.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong! Try later again or sign in again.'**
  String get error_authentication_internal;

  /// No description provided for @error_authentication_disabled.
  ///
  /// In en, this message translates to:
  /// **'The authenticated account was disabled by an administrator. You will be signed out automatically'**
  String get error_authentication_disabled;

  /// No description provided for @error_general.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong!'**
  String get error_general;

  /// No description provided for @error_no_personal_record_selected.
  ///
  /// In en, this message translates to:
  /// **'There is no Personal Record selected. Select one or create a new one, to be able to select it.'**
  String get error_no_personal_record_selected;

  /// No description provided for @error_no_body_weight_values.
  ///
  /// In en, this message translates to:
  /// **'You have no body weight values defined in the last month. To make your body weight your goal, you need to add a value to it first, so we can track it.'**
  String get error_no_body_weight_values;

  /// No description provided for @error_no_body_fat_values.
  ///
  /// In en, this message translates to:
  /// **'You have no body fat values defined in the last month. To make your body fat your goal, you need to add a value to it first, so we can track it'**
  String get error_no_body_fat_values;

  /// No description provided for @error_too_many_personal_records.
  ///
  /// In en, this message translates to:
  /// **'You can have a maximum of 20 Personal Records'**
  String get error_too_many_personal_records;

  /// No description provided for @invalid_trainings.
  ///
  /// In en, this message translates to:
  /// **'The following trainings are invalid:'**
  String get invalid_trainings;

  /// No description provided for @label_superset.
  ///
  /// In en, this message translates to:
  /// **'Combine as superset with below:'**
  String get label_superset;

  /// No description provided for @your_body_stats_label.
  ///
  /// In en, this message translates to:
  /// **'Body Stats:'**
  String get your_body_stats_label;

  /// No description provided for @now_label.
  ///
  /// In en, this message translates to:
  /// **'Current:'**
  String get now_label;

  /// No description provided for @selected_label.
  ///
  /// In en, this message translates to:
  /// **'Selected:'**
  String get selected_label;

  /// No description provided for @create_body_value_title.
  ///
  /// In en, this message translates to:
  /// **'Set todays Body Value'**
  String get create_body_value_title;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @add_today_value.
  ///
  /// In en, this message translates to:
  /// **'Add value for today'**
  String get add_today_value;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @goal_finished_text.
  ///
  /// In en, this message translates to:
  /// **'You\'ve just reached your next milestone and unlocked a new card. Don\'t forget to save it and share with your friends'**
  String get goal_finished_text;

  /// No description provided for @goal_finished_title.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get goal_finished_title;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @go_back.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get go_back;

  /// No description provided for @search_email.
  ///
  /// In en, this message translates to:
  /// **'Search Email'**
  String get search_email;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @search_account_instruction.
  ///
  /// In en, this message translates to:
  /// **'To add a friend, type in the email of the account'**
  String get search_account_instruction;

  /// No description provided for @search_account_account_found.
  ///
  /// In en, this message translates to:
  /// **'The following account with the Email {email} was found:'**
  String search_account_account_found(String email);

  /// No description provided for @copied_mail.
  ///
  /// In en, this message translates to:
  /// **'Copied your mail to clipboard'**
  String get copied_mail;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
