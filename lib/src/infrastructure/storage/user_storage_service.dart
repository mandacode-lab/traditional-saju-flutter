import 'package:traditional_saju/src/domain/user/entity/user.dart';
import 'package:traditional_saju/src/domain/user/value/dating_status.dart';
import 'package:traditional_saju/src/domain/user/value/gender.dart';
import 'package:traditional_saju/src/domain/user/value/job_status.dart';
import 'package:traditional_saju/src/infrastructure/storage/drift/database.dart';

class UserStorageService {
  UserStorageService({required this.database});

  final AppDatabase database;

  Future<void> saveUserInfo(UserInfo userInfo) async {
    // Delete existing data first
    await database.delete(database.userInfoTable).go();

    // Insert new data
    await database
        .into(database.userInfoTable)
        .insert(
          UserInfoTableCompanion.insert(
            gender: userInfo.gender.toString().split('.').last,
            jobStatus: userInfo.jobStatus.toString().split('.').last,
            datingStatus: userInfo.datingStatus.toString().split('.').last,
            birthdate: userInfo.birthdate,
            permanent: userInfo.permanent,
          ),
        );
  }

  Future<UserInfo?> getUserInfo() async {
    final userInfo = await database
        .select(database.userInfoTable)
        .getSingleOrNull();
    if (userInfo == null) return null;

    return UserInfo(
      gender: _parseGender(userInfo.gender),
      jobStatus: _parseJobStatus(userInfo.jobStatus),
      datingStatus: _parseDatingStatus(userInfo.datingStatus),
      birthdate: userInfo.birthdate,
      permanent: userInfo.permanent,
    );
  }

  Future<void> deleteUserInfo() async {
    await database.delete(database.userInfoTable).go();
  }

  Gender _parseGender(String value) {
    switch (value) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.male;
    }
  }

  JobStatus _parseJobStatus(String value) {
    switch (value) {
      case 'employed':
        return JobStatus.employed;
      case 'unemployed':
        return JobStatus.unemployed;
      case 'student':
        return JobStatus.student;
      default:
        return JobStatus.student;
    }
  }

  DatingStatus _parseDatingStatus(String value) {
    switch (value) {
      case 'single':
        return DatingStatus.single;
      case 'dating':
        return DatingStatus.dating;
      case 'married':
        return DatingStatus.married;
      default:
        return DatingStatus.single;
    }
  }
}
