import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_builder;
import 'package:intl/intl.dart';
import 'location.dart';

enum Gender { MALE, FEMALE }

class AppUser {
  final String firebaseUid;
  final String firstName;
  final String lastName;
  final String email;

  final String? profilePicture;
  final String? about;
  final String? instagram;
  final String? twitter;
  final String? linkedIn;
  final String? tikTok;
  final String? stripeCustomerId;

  final DateTime? dob;
  final DateTime? challengeStartDate;
  final DateTime? challengeCompletionDate;
  final DateTime registrationDate;

  final int? pagesRead;
  final int? workoutMinutes;
  final int? challengeAttempts;
  final int? longestStreak;

  final bool completedOnboarding;

  final Gender? gender;

  final Location? location;

  final List<dynamic> deviceTokens;
  final List<dynamic> personalGoals;
  final List<dynamic> tasksNotCompletedOnFailureDay;

  final Map<String, Set> completions;
  final Map<String, dynamic> journalEntries;
  final Map<String, dynamic> totalMessagesReadInChats;

  int? messagesReadInChat(String chatId) {
    return totalMessagesReadInChats[chatId];
  }

  AppUser._({
    required this.firebaseUid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.registrationDate,
    this.profilePicture,
    this.about,
    this.instagram,
    this.twitter,
    this.linkedIn,
    this.tikTok,
    this.dob,
    this.gender,
    this.location,
    this.pagesRead,
    this.workoutMinutes,
    this.challengeAttempts,
    this.longestStreak,
    this.stripeCustomerId,
    this.challengeStartDate,
    this.challengeCompletionDate,
    this.tasksNotCompletedOnFailureDay = const [],
    this.personalGoals = const [],
    this.deviceTokens = const [],
    this.completions = const {},
    this.journalEntries = const {},
    this.totalMessagesReadInChats = const {},
    this.completedOnboarding = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final newUser = AppUser._(
      firebaseUid: json['firebaseUid'],
      profilePicture: json['profilePicture'],
      about: json['about'],
      instagram: json['instagram'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      location: json['location'] == null ? null : Location.fromJson(json['location']),
      stripeCustomerId: json['stripeCustomerId'],
      dob: json['dob'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['dob']),
      challengeCompletionDate: json['challengeCompletionDate'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['challengeCompletionDate']),
      challengeStartDate:
          json['challengeStartDate'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['challengeStartDate']),
      registrationDate: DateTime.fromMillisecondsSinceEpoch(json['registrationDate']),
      deviceTokens: json['deviceTokens'] ?? [],
      twitter: json['twitter'],
      linkedIn: json['linkedIn'],
      tikTok: json['tikTok'],
      personalGoals: json['personalGoals'] ?? [],
      pagesRead: json['pagesRead'] ?? 0,
      workoutMinutes: json['workoutMinutes'] ?? 0,
      challengeAttempts: json['challengeAttempts'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      journalEntries: json['journalEntries'] ?? {},
      gender: json['gender'] == 'MALE'
          ? Gender.MALE
          : json['gender'] == 'FEMALE'
              ? Gender.FEMALE
              : null,
      completedOnboarding: json['completedOnboarding'] ?? false,
      tasksNotCompletedOnFailureDay: json['tasksNotCompletedOnFailureDay'] ?? [],
      totalMessagesReadInChats: json['totalMessagesReadInChats'] ?? {},
      completions: (json['completions'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, (value as List).toSet()),
      ),
    );

    return newUser;
  }

  Map<String, dynamic> toJson() {
    return {
      'firebaseUid': this.firebaseUid,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'email': this.email,
      'profilePicture': this.profilePicture,
      'instagram': this.instagram,
      'twitter': this.twitter,
      'linkedIn': this.linkedIn,
      'tikTok': this.tikTok,
      'about': this.about,
      'location': location?.toJson(),
      'dob': this.dob?.millisecondsSinceEpoch,
      'challengeCompletionDate': this.challengeCompletionDate?.millisecondsSinceEpoch,
      'challengeStartDate': this.challengeStartDate?.millisecondsSinceEpoch,
      'stripeCustomerId': this.stripeCustomerId,
      'registrationDate': this.registrationDate.millisecondsSinceEpoch,
      'totalMessagesReadInChats': totalMessagesReadInChats,
      'deviceTokens': deviceTokens,
      'journalEntries': journalEntries,
      'completions': completions.map((key, value) => MapEntry(key, value.toList())),
      'completedOnboarding': completedOnboarding,
      'gender': this.gender?.name,
      'personalGoals': personalGoals,
      'pagesRead': pagesRead,
      'workoutMinutes': workoutMinutes,
      'challengeAttempts': challengeAttempts,
      'longestStreak': longestStreak,
      'tasksNotCompletedOnFailureDay': tasksNotCompletedOnFailureDay,
    };
  }

  AppUser copyWith({
    String? firebaseUid,
    String? firstName,
    String? lastName,
    String? email,
    String? profilePicture,
    String? about,
    String? instagram,
    String? twitter,
    String? linkedIn,
    String? tikTok,
    int? pagesRead,
    int? workoutMinutes,
    int? challengeAttempts,
    int? longestStreak,
    DateTime? dob,
    Location? location,
    String? stripeCustomerId,
    DateTime? registrationDate,
    DateTime? challengeStartDate,
    DateTime? challengeCompletionDate,
    bool? completedOnboarding,
    Gender? gender,
    List? personalGoals,
    Map<String, Set<int>>? completions,
    Iterable? tasksNotCompletedOnFailureDay,
  }) {
    return AppUser._(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      about: about ?? this.about,
      instagram: instagram ?? this.instagram,
      twitter: twitter ?? this.twitter,
      linkedIn: linkedIn ?? this.linkedIn,
      tikTok: tikTok ?? this.tikTok,
      dob: dob ?? this.dob,
      pagesRead: pagesRead ?? this.pagesRead,
      workoutMinutes: workoutMinutes ?? this.workoutMinutes,
      challengeAttempts: challengeAttempts ?? this.challengeAttempts,
      longestStreak: longestStreak ?? this.longestStreak,
      location: location ?? this.location,
      challengeStartDate: challengeStartDate ?? this.challengeStartDate,
      challengeCompletionDate: challengeCompletionDate ?? this.challengeCompletionDate,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      registrationDate: registrationDate ?? this.registrationDate,
      completedOnboarding: completedOnboarding ?? this.completedOnboarding,
      deviceTokens: this.deviceTokens,
      gender: gender ?? this.gender,
      journalEntries: this.journalEntries,
      personalGoals: personalGoals ?? this.personalGoals,
      completions: completions ?? this.completions,
      totalMessagesReadInChats: this.totalMessagesReadInChats,
      tasksNotCompletedOnFailureDay: tasksNotCompletedOnFailureDay?.toList() ?? this.tasksNotCompletedOnFailureDay,
    );
  }

  void addJournalEntry(String entry) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    journalEntries[formattedDate] = entry;
  }


  void updateChatsMap(Map<String, dynamic> totalMessagesReadInChats) {
    totalMessagesReadInChats.addAll(totalMessagesReadInChats);
  }

  AppUser copyWithNewValue(String key, Object value) {
    final currentUserJson = toJson();
    currentUserJson[key] = value;
    return AppUser.fromJson(currentUserJson);
  }

  int? get age {
    if (dob == null) return null;
    final currentDate = DateTime.now();
    int age = currentDate.year - dob!.year;
    if (currentDate.month < dob!.month || (currentDate.month == dob!.month && currentDate.day < dob!.day)) {
      age--;
    }
    return age;
  }

  chat_builder.User toChatBuilderUser() {
    return chat_builder.User(
      id: firebaseUid,
      firstName: firstName,
      lastName: lastName,
      imageUrl: profilePicture?.isEmpty ?? true ? null : profilePicture,
    );
  }

  String get fullNameShort {
    ;
    return fullName.length > 10
        ? '$firstName ${lastName[0]}.'.length > 12
            ? firstName
            : '$firstName ${lastName[0]}.'
        : fullName;
  }

  String get fullName => lastName.isEmpty ? firstName : '$firstName $lastName';

  String get username => '$firstName$lastName'.replaceAll(' ', '').toLowerCase();

  @override
  String toString() => '$firstName $lastName\n($email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser && runtimeType == other.runtimeType && firebaseUid == other.firebaseUid;

  @override
  int get hashCode => firebaseUid.hashCode;
}
