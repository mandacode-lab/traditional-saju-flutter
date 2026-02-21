import 'package:traditional_saju/src/application/ports/saju/saju_port.dart';
import 'package:traditional_saju/src/domain/saju/entity/daily_fortune.dart';
import 'package:traditional_saju/src/domain/saju/entity/yearly_fortune.dart';
import 'package:traditional_saju/src/infrastructure/client/api_client.dart';
import 'package:traditional_saju/src/infrastructure/dto/saju/daily_fortune_response_dto.dart';
import 'package:traditional_saju/src/infrastructure/dto/saju/daily_saju_request_dto.dart';
import 'package:traditional_saju/src/infrastructure/dto/saju/yearly_fortune_response_dto.dart';
import 'package:traditional_saju/src/infrastructure/dto/saju/yearly_saju_request_dto.dart';
import 'package:traditional_saju/src/infrastructure/storage/user_storage_service.dart';

/// Implementation of SajuPort using REST API
class SajuAdapter implements SajuPort {
  const SajuAdapter({
    required ApiClient apiClient,
    required UserStorageService userStorage,
  }) : _apiClient = apiClient,
       _userStorage = userStorage;

  final ApiClient _apiClient;
  final UserStorageService _userStorage;

  @override
  Future<DailyFortune> getDailyFortune() async {
    final userInfo = await _userStorage.getUserInfo();
    if (userInfo == null) {
      throw Exception('User info not found');
    }

    // Convert to UTC and format as ISO8601 with Z suffix
    final birthDateTimeUtc = userInfo.birthdate.toUtc();
    final formattedDateTime = birthDateTimeUtc.toIso8601String();

    final request = DailySajuRequestDto(
      birthDateTime: formattedDateTime,
      gender: userInfo.gender.toString().split('.').last,
      datingStatus: userInfo.datingStatus.toString().split('.').last,
      jobStatus: userInfo.jobStatus.toString().split('.').last,
    );

    final responseData = await _callDailySajuApi(request);
    final dto = DailyFortuneResponseDto.fromJson(responseData);
    return dto.toDomain();
  }

  @override
  Future<YearlyFortune> getYearlyFortune() async {
    final userInfo = await _userStorage.getUserInfo();
    if (userInfo == null) {
      throw Exception('User info not found');
    }

    final birthDateTime = userInfo.birthdate.toIso8601String();

    final request = YearlySajuRequestDto(
      gender: userInfo.gender.toString().split('.').last,
      birthDateTime: birthDateTime,
      datingStatus: userInfo.datingStatus.toString().split('.').last,
      jobStatus: userInfo.jobStatus.toString().split('.').last,
      birthTimeDisabled:
          userInfo.birthdate.hour == 0 && userInfo.birthdate.minute == 0,
      question: '',
    );

    final responseData = await _callYearlySajuApi(request);
    final dto = YearlyFortuneResponseDto.fromJson(responseData);
    return dto.toDomain();
  }

  // Helper method for future use
  Future<Map<String, dynamic>> _callDailySajuApi(
    DailySajuRequestDto request,
  ) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/saju/daily',
      data: request.toJson(),
    );

    if (response.data == null) {
      throw Exception('Daily saju request failed: No response data');
    }

    return response.data!;
  }

  // Helper method for future use
  Future<Map<String, dynamic>> _callYearlySajuApi(
    YearlySajuRequestDto request,
  ) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      '/saju/yearly',
      data: request.toJson(),
    );

    if (response.data == null) {
      throw Exception('Yearly saju request failed: No response data');
    }

    return response.data!;
  }
}
