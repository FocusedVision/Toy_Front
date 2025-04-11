part of 'notification_cubit.dart';

class NotificationSettingsState {
  final bool isEnabled;
  final bool isLoading;
  final String? error;

  NotificationSettingsState({
    this.isEnabled = false,
    this.isLoading = false,
    this.error,
  });

  NotificationSettingsState copyWith({
    bool? isEnabled,
    bool? isLoading,
    String? error,
  }) {
    return NotificationSettingsState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
