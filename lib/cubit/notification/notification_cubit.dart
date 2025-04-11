import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/data/network/network_repository.dart';
import '../../config/get_it.dart';

part 'notification_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final _networkRepository = getIt.get<NetworkRepository>();

  NotificationSettingsCubit() : super(NotificationSettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await _networkRepository.getNotificationSettings();
      print("Notification State: ${response.data['isEnabled']}");
      if (response.success) {
        emit(state.copyWith(
          isEnabled: response.data['isEnabled'],
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load settings',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> toggleNewToysNotifications(bool value) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await _networkRepository.updateNotificationSettings(
        isEnabled: value,
      );
      if (response.success) {
        emit(state.copyWith(
          isEnabled: value,
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to update settings',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
