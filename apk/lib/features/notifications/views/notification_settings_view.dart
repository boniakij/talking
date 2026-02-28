import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../models/notification_model.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(LoadNotificationSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationSettingsLoaded) {
            return _buildSettingsList(state.settings);
          }

          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSettingsList(NotificationSettings settings) {
    return ListView(
      children: [
        _buildSectionHeader('Notification Types'),
        _buildSwitchTile(
          icon: Icons.message,
          title: 'Messages',
          subtitle: 'Get notified when you receive new messages',
          value: settings.messagesEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('messages', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.call,
          title: 'Calls',
          subtitle: 'Get notified for incoming voice and video calls',
          value: settings.callsEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('calls', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.favorite,
          title: 'Matches',
          subtitle: 'Get notified when you have new matches',
          value: settings.matchesEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('matches', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.card_giftcard,
          title: 'Gifts',
          subtitle: 'Get notified when you receive gifts',
          value: settings.giftsEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('gifts', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.person_add,
          title: 'Follows',
          subtitle: 'Get notified when someone follows you',
          value: settings.followsEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('follows', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.info,
          title: 'System',
          subtitle: 'Get important system updates and announcements',
          value: settings.systemEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('system', value),
            );
          },
        ),
        const Divider(),
        _buildSectionHeader('Sound & Vibration'),
        _buildSwitchTile(
          icon: Icons.volume_up,
          title: 'Notification Sound',
          subtitle: 'Play sound for notifications',
          value: settings.soundEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('sound', value),
            );
          },
        ),
        _buildSwitchTile(
          icon: Icons.vibration,
          title: 'Vibration',
          subtitle: 'Vibrate on notifications',
          value: settings.vibrationEnabled,
          onChanged: (value) {
            context.read<NotificationBloc>().add(
              const UpdateNotificationSettings('vibration', value),
            );
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You can also manage notification permissions in your device settings.',
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
