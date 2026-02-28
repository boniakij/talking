import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sl_bloc.dart';
import '../bloc/sl_event.dart';
import '../bloc/sl_state.dart';
import '../views/tongue_twister_levels_view.dart';
import '../services/sl_service.dart';
import '../../../core/network/api_client.dart';

class SlMainView extends StatelessWidget {
  const SlMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SlBloc(
        SlService(ApiClient().dio),
      ),
      child: const _SlMainViewContent(),
    );
  }
}

class _SlMainViewContent extends StatelessWidget {
  const _SlMainViewContent();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Speech Learning'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.school),
                text: 'Learn',
              ),
              Tab(
                icon: Icon(Icons.psychology),
                text: 'Practice',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LearnTab(),
            TongueTwisterLevelsView(),
          ],
        ),
      ),
    );
  }
}

class _LearnTab extends StatelessWidget {
  const _LearnTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.record_voice_over,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Speech Learning',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Master pronunciation with AI-powered feedback',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Features',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildFeatureCard(
            context,
            icon: Icons.waves,
            title: 'Pronunciation Coach',
            description: 'Get real-time feedback on your pronunciation with waveform visualization',
            color: Colors.blue,
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.psychology,
            title: 'Tongue Twisters',
            description: 'Challenge yourself with progressively difficult tongue twisters',
            color: Colors.purple,
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.leaderboard,
            title: 'Leaderboards',
            description: 'Compete with others and see who has the best pronunciation',
            color: Colors.orange,
          ),
          
          _buildFeatureCard(
            context,
            icon: Icons.analytics,
            title: 'Progress Tracking',
            description: 'Monitor your improvement over time with detailed analytics',
            color: Colors.green,
          ),
          
          const SizedBox(height: 24),
          
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pro Tip',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start with easy tongue twisters and gradually work your way up. Practice daily for best results!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switch to Practice tab to use $title'),
              action: SnackBarAction(
                label: 'Practice',
                onPressed: () {
                  DefaultTabController.of(context).animateTo(1);
                },
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
