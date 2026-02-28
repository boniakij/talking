import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/matching_bloc.dart';
import '../bloc/matching_event.dart';
import '../bloc/matching_state.dart';
import '../models/potential_match.dart';
import '../widgets/accuracy_meter.dart';

class DiscoveryDeckView extends StatefulWidget {
  const DiscoveryDeckView({super.key});

  @override
  State<DiscoveryDeckView> createState() => _DiscoveryDeckViewState();
}

class _DiscoveryDeckViewState extends State<DiscoveryDeckView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<MatchingBloc>().add(LoadPotentialMatches());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: BlocConsumer<MatchingBloc, MatchingState>(
        listener: (context, state) {
          if (state is MatchSuccess) {
            _showMatchDialog(state.match);
          }
        },
        builder: (context, state) {
          if (state is MatchingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MatchingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<MatchingBloc>().add(RefreshMatches()),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is MatchesExhausted) {
            return _buildEmptyState();
          }

          if (state is PotentialMatchesLoaded && state.matches.isNotEmpty) {
            return _buildCardDeck(state);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCardDeck(PotentialMatchesLoaded state) {
    final matches = state.matches;
    final currentIndex = state.currentIndex;

    if (matches.isEmpty || currentIndex >= matches.length) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: matches.length - currentIndex,
              itemBuilder: (context, index) {
                final matchIndex = currentIndex + index;
                if (matchIndex >= matches.length) return const SizedBox.shrink();
                return _buildMatchCard(matches[matchIndex]);
              },
            ),
          ),
        ),
        _buildActionButtons(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMatchCard(PotentialMatch match) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background with gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.3),
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            
            // Avatar or placeholder
            Center(
              child: match.avatar != null
                  ? Image.network(
                      match.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          _buildPlaceholderAvatar(),
                    )
                  : _buildPlaceholderAvatar(),
            ),

            // Gradient overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${match.username}, ${match.age ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (match.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            match.location!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (match.nativeLanguage != null && match.learningLanguage != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildLanguageBadge(match.nativeLanguage!, Colors.green),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          _buildLanguageBadge(match.learningLanguage!, Colors.orange),
                        ],
                      ),
                    ],
                    if (match.bio != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        match.bio!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Compatibility badge
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: match.hasHighCompatibility ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      match.compatibilityPercentage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.person, size: 100, color: Colors.grey),
    );
  }

  Widget _buildLanguageBadge(String language, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        language,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            onPressed: () {
              final state = context.read<MatchingBloc>().state;
              if (state is PotentialMatchesLoaded && state.currentMatch != null) {
                context.read<MatchingBloc>().add(SwipeLeft(state.currentMatch!.id));
              }
              if (_currentIndex < state.matches.length - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
          ),
          _buildActionButton(
            icon: Icons.undo,
            color: Colors.amber,
            onPressed: () => context.read<MatchingBloc>().add(UndoLastSwipe()),
          ),
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            onPressed: () {
              final state = context.read<MatchingBloc>().state;
              if (state is PotentialMatchesLoaded && state.currentMatch != null) {
                context.read<MatchingBloc>().add(SuperLike(state.currentMatch!.id));
                if (_currentIndex < state.matches.length - 1) {
                  _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              }
            },
          ),
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            onPressed: () {
              final state = context.read<MatchingBloc>().state;
              if (state is PotentialMatchesLoaded && state.currentMatch != null) {
                context.read<MatchingBloc>().add(SwipeRight(state.currentMatch!.id));
              }
              if (_currentIndex < state.matches.length - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        iconSize: 30,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No more profiles',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new matches!',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<MatchingBloc>().add(RefreshMatches()),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  void _showMatchDialog(PotentialMatch match) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'It\'s a Match!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: match.avatar != null 
                    ? NetworkImage(match.avatar!) 
                    : null,
                child: match.avatar == null 
                    ? const Icon(Icons.person, size: 50) 
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                'You and ${match.username} liked each other!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              AccuracyMeter(
                compatibilityScore: match.compatibilityScore,
                sharedInterests: match.sharedInterests,
                allInterests: match.interests,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigate to chat
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Say Hello'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Keep Swiping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog() {
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
        expand: false,
        builder: (context, scrollController) => _FilterSheet(
          scrollController: scrollController,
          onApply: (filters) {
            context.read<MatchingBloc>().add(FilterMatches(
              language: filters['language'],
              minAge: filters['minAge'],
              maxAge: filters['maxAge'],
              interests: filters['interests'],
            ));
          },
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onApply;

  const _FilterSheet({
    required this.scrollController,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String? _selectedLanguage;
  RangeValues _ageRange = const RangeValues(18, 50);
  final List<String> _selectedInterests = [];

  final List<String> _availableInterests = [
    'Languages', 'Travel', 'Music', 'Sports', 'Reading',
    'Technology', 'Art', 'Cooking', 'Photography', 'Gaming',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
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
          Row(
            children: [
              const Icon(Icons.filter_list, size: 28),
              const SizedBox(width: 8),
              Text(
                'Filter Matches',
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
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: [
                Text(
                  'Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: ['English', 'Spanish', 'French', 'German', 'Japanese', 'Korean']
                      .map((lang) => ChoiceChip(
                        label: Text(lang),
                        selected: _selectedLanguage == lang,
                        onSelected: (selected) {
                          setState(() {
                            _selectedLanguage = selected ? lang : null;
                          });
                        },
                      ))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Age Range: ${_ageRange.start.toInt()} - ${_ageRange.end.toInt()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RangeSlider(
                  values: _ageRange,
                  min: 18,
                  max: 80,
                  divisions: 62,
                  labels: RangeLabels(
                    _ageRange.start.toInt().toString(),
                    _ageRange.end.toInt().toString(),
                  ),
                  onChanged: (values) {
                    setState(() {
                      _ageRange = values;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'Interests',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableInterests.map((interest) {
                    final isSelected = _selectedInterests.contains(interest);
                    return FilterChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedInterests.add(interest);
                          } else {
                            _selectedInterests.remove(interest);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply({
                  'language': _selectedLanguage,
                  'minAge': _ageRange.start.toInt(),
                  'maxAge': _ageRange.end.toInt(),
                  'interests': _selectedInterests.isEmpty ? null : _selectedInterests,
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
