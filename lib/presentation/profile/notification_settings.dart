import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/notification/notification_cubit.dart';
import 'package:virtual_toy_shop/widgets/app_bars/main_app_bar.dart';
import '../../widgets/app_bars/simple_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationSettingsCubit(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const SimpleAppBar(
          title: 'Notification',
        ),
        body: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight + 80),
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    NotificationSettingTile(
                      title: 'New Toys',
                      subtitle: 'Get notified when new toys are added',
                      value: state.isEnabled,
                      onChanged: (value) {
                        context
                            .read<NotificationSettingsCubit>()
                            .toggleNewToysNotifications(value);
                      },
                    ),
                    const Divider(height: 1),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationSettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const NotificationSettingTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MyColors.greenShadow,
          ),
        ],
      ),
    );
  }
}
