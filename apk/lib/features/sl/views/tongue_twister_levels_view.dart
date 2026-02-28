import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sl_bloc.dart';
import '../bloc/sl_event.dart';
import '../bloc/sl_state.dart';
import '../models/tongue_twister.dart';
import '../views/pronunciation_coach_view.dart';

class TongueTwisterLevelsView extends StatefulWidget {
  const TongueTwisterLevelsView({super.key});

  @override
  State<TongueTwisterLevelsView> createState() => _TongueTwisterLevelsViewState();
}

class _TongueTwisterLevelsViewState extends State<TongueTwisterLevelsView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<SlBloc>().add(LoadTongueTwisters());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tongue Twister Challenge'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Easy'),
            Tab(text: 'Medium'),
            Tab(text: 'Hard'),
            Tab(text: 'Master'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            onPressed: () {
              context.read<SlBloc>().add(LoadLeaderboard());
              _showLeaderboard();
            },
          ),
        ],
      ),
      body: BlocBuilder<SlBloc, SlState>(
        builder: (context, state) {
          if (state is SlLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SlError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<SlBloc>().add(LoadTongueTwisters()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TongueTwistersLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildLevelList(state.tongueTwisters.where((t) => t.difficulty == 'Easy').toList()),
                _buildLevelList(state.tongueTwisters.where((t) => t.difficulty == 'Medium').toList()),
                _buildLevelList(state.tongueTwisters.where((t) => t.difficulty == 'Hard').toList()),
                _buildLevelList(state.tongueTwisters.where((t) => t.difficulty == 'Master').toList()),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLevelList(List<TongueTwister> tongueTwisters) {
    if (tongueTwisters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No challenges available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete previous levels to unlock',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tongueTwisters.length,
      itemBuilder: (context, index) {
        final twister = tongueTwisters[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          child: InkWell(
            onTap: twister.isUnlocked
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PronunciationCoachView(tongueTwister: twister),
                      ),
                    );
                  }
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: twister.isUnlocked
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: twister.isUnlocked
                              ? Text(
                                  twister.difficultyEmoji,
                                  style: const TextStyle(fontSize: 24),
                                )
                              : Icon(
                                  Icons.lock,
                                  color: Colors.grey[600],
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Challenge ${index + 1}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: twister.isUnlocked ? null : Colors.grey,
                              ),
                            ),
                            if (twister.isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (twister.bestScore != null)
                        Column(
                          children: [
                            Text(
                              '${twister.bestScore}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _getScoreColor(twister.bestScore!),
                              ),
                            ),
                            Text(
                              'Best Score',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    twister.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: twister.isUnlocked ? null : Colors.grey,
                    ),
                  ),
                  if (twister.translation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      twister.translation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: twister.isUnlocked ? Colors.grey[600] : Colors.grey,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (!twister.isUnlocked)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<SlBloc>().add(UnlockTongueTwister(twister.id));
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Unlock Challenge'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PronunciationCoachView(tongueTwister: twister),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLeaderboard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => BlocBuilder<SlBloc, SlState>(
          builder: (context, state) {
            if (state is LeaderboardLoaded) {
              return _buildLeaderboardContent(state.entries, scrollController);
            }
            if (state is SlLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const Center(child: Text('No leaderboard data available'));
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboardContent(List entries, ScrollController scrollController) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.leaderboard, size: 28),
              const SizedBox(width: 8),
              Text(
                'Leaderboard',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(entry.rank),
                      child: Text(
                        entry.rankBadge,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(entry.username),
                    subtitle: Text(
                      'Score: ${entry.score}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formatTime(entry.completedAt),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entry.tongueTwisterText.length > 20
                                ? '${entry.tongueTwisterText.substring(0, 20)}...'
                                : entry.tongueTwisterText,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.lightGreen;
    if (score >= 70) return Colors.orange;
    if (score >= 60) return Colors.deepOrange;
    return Colors.red;
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
