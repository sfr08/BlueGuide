import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 1)
class UserProfile {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String bankAccountNumber;

  @HiveField(3)
  String ifscCode;

  @HiveField(4)
  int blueCoins;

  UserProfile({
    required this.name,
    required this.email,
    required this.bankAccountNumber,
    required this.ifscCode,
    this.blueCoins = 0,
  });

  // Factory constructor for an empty profile
  factory UserProfile.empty() {
    return UserProfile(
      name: "",
      email: "",
      bankAccountNumber: "",
      ifscCode: "",
      blueCoins: 0,
    );
  }
}
