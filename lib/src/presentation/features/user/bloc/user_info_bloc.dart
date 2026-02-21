import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traditional_saju/src/domain/user/entity/user.dart';
import 'package:traditional_saju/src/infrastructure/storage/user_storage_service.dart';
import 'package:traditional_saju/src/presentation/features/user/bloc/user_info_event.dart';
import 'package:traditional_saju/src/presentation/features/user/bloc/user_info_state.dart';

/// BLoC for managing user information input
class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  UserInfoBloc({
    required UserStorageService userStorage,
  }) : _userStorage = userStorage,
       super(const UserInfoState()) {
    on<UserInfoLoadRequested>(_onLoadRequested);
    on<UserInfoGenderChanged>(_onGenderChanged);
    on<UserInfoBirthDateChanged>(_onBirthDateChanged);
    on<UserInfoBirthHourChanged>(_onBirthHourChanged);
    on<UserInfoBirthMinutesChanged>(_onBirthMinutesChanged);
    on<UserInfoTimeUnknownChanged>(_onTimeUnknownChanged);
    on<UserInfoDatingStatusChanged>(_onDatingStatusChanged);
    on<UserInfoJobStatusChanged>(_onJobStatusChanged);
    on<UserInfoPermanentChanged>(_onPermanentChanged);
    on<UserInfoSubmitted>(_onSubmitted);
  }

  final UserStorageService _userStorage;

  Future<void> _onLoadRequested(
    UserInfoLoadRequested event,
    Emitter<UserInfoState> emit,
  ) async {
    emit(state.copyWith(status: UserInfoStatus.loading));
    try {
      final userInfo = await _userStorage.getUserInfo();
      if (userInfo != null) {
        emit(
          state.copyWith(
            status: UserInfoStatus.success,
            gender: userInfo.gender,
            birthDate: userInfo.birthdate,
            birthHour: userInfo.birthdate.hour,
            birthMinutes: userInfo.birthdate.minute,
            datingStatus: userInfo.datingStatus,
            jobStatus: userInfo.jobStatus,
            permanent: userInfo.permanent,
          ),
        );
      } else {
        emit(state.copyWith(status: UserInfoStatus.success));
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: UserInfoStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void _onGenderChanged(
    UserInfoGenderChanged event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith(gender: event.gender));
  }

  void _onBirthDateChanged(
    UserInfoBirthDateChanged event,
    Emitter<UserInfoState> emit,
  ) {
    // Update birthDate while preserving hour and minutes
    final newBirthDate = DateTime(
      event.birthDate.year,
      event.birthDate.month,
      event.birthDate.day,
      state.birthHour,
      state.birthMinutes,
    );
    emit(state.copyWith(birthDate: newBirthDate));
  }

  void _onBirthHourChanged(
    UserInfoBirthHourChanged event,
    Emitter<UserInfoState> emit,
  ) {
    if (state.birthDate != null) {
      final newBirthDate = DateTime(
        state.birthDate!.year,
        state.birthDate!.month,
        state.birthDate!.day,
        event.birthHour,
        state.birthMinutes,
      );
      emit(
        state.copyWith(
          birthHour: event.birthHour,
          birthDate: newBirthDate,
        ),
      );
    } else {
      emit(state.copyWith(birthHour: event.birthHour));
    }
  }

  void _onBirthMinutesChanged(
    UserInfoBirthMinutesChanged event,
    Emitter<UserInfoState> emit,
  ) {
    if (state.birthDate != null) {
      final newBirthDate = DateTime(
        state.birthDate!.year,
        state.birthDate!.month,
        state.birthDate!.day,
        state.birthHour,
        event.birthMinutes,
      );
      emit(
        state.copyWith(
          birthMinutes: event.birthMinutes,
          birthDate: newBirthDate,
        ),
      );
    } else {
      emit(state.copyWith(birthMinutes: event.birthMinutes));
    }
  }

  void _onTimeUnknownChanged(
    UserInfoTimeUnknownChanged event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith(timeUnknown: event.timeUnknown));
  }

  void _onDatingStatusChanged(
    UserInfoDatingStatusChanged event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith(datingStatus: event.datingStatus));
  }

  void _onJobStatusChanged(
    UserInfoJobStatusChanged event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith(jobStatus: event.jobStatus));
  }

  void _onPermanentChanged(
    UserInfoPermanentChanged event,
    Emitter<UserInfoState> emit,
  ) {
    emit(state.copyWith(permanent: event.permanent));
  }

  Future<void> _onSubmitted(
    UserInfoSubmitted event,
    Emitter<UserInfoState> emit,
  ) async {
    if (!state.isBaseInfoValid || state.birthDate == null) {
      emit(
        state.copyWith(
          status: UserInfoStatus.failure,
          error: 'Please fill all required fields',
        ),
      );
      return;
    }

    emit(state.copyWith(status: UserInfoStatus.loading));
    try {
      final userInfo = UserInfo(
        gender: state.gender,
        jobStatus: state.jobStatus,
        datingStatus: state.datingStatus,
        birthdate: state.birthDate!,
        permanent: state.permanent,
      );

      await _userStorage.saveUserInfo(userInfo);
      emit(state.copyWith(status: UserInfoStatus.submitted));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: UserInfoStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
