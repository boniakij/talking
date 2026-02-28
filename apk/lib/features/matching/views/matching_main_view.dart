import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/matching_service.dart';
import '../bloc/matching_bloc.dart';
import '../views/discovery_deck_view.dart';
import '../../../core/services/dio_service.dart';

class MatchingMainView extends StatelessWidget {
  const MatchingMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchingBloc(
        MatchingService(DioService.instance.dio),
      ),
      child: const MatchingMainViewContent(),
    );
  }
}

class MatchingMainViewContent extends StatefulWidget {
  const MatchingMainViewContent({super.key});

  @override
  State<MatchingMainViewContent> createState() => _MatchingMainViewContentState();
}

class _MatchingMainViewContentState extends State<MatchingMainViewContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DiscoveryDeckView(),
    const _MatchesListView(),
    const _LikesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showMatchingSettings,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Likes',
          ),
        ],
      ),
    );
  }

  void _showMatchingSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Matching Preferences',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              subtitle: const Text('Show matches near me'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Native Language'),
              subtitle: const Text('Match with language learners'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('New Match Notifications'),
              subtitle: const Text('Get notified of new matches'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Preferences'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchesListView extends StatelessWidget {
  const _MatchesListView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://api.dicebear.com/7.x/avataaars/svg?seed=match$index',
              ),
            ),
            title: Text('Match ${index + 1}'),
            subtitle: Text('Matched ${index + 1} days ago'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // Navigate to chat
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LikesView extends StatelessWidget {
  const _LikesView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://api.dicebear.com/7.x/avataaars/svg?seed=like$index',
              ),
            ),
            title: Text('Someone liked you'),
            subtitle: const Text('Swipe right to see who'),
            trailing: ElevatedButton(
              onPressed: () {
                // Unlock or subscribe to see who liked
              },
              child: const Text('See Who'),
            ),
          ),
        );
      },
    );
  }
}
