import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sl_bloc.dart';
import '../bloc/sl_event.dart';
import '../bloc/sl_state.dart';
import '../models/tongue_twister.dart';
import '../widgets/pronunciation_score_card.dart';
import '../widgets/waveform_visualizer.dart';

class PronunciationCoachView extends StatefulWidget {
  final TongueTwister tongueTwister;

  const PronunciationCoachView({
    super.key,
    required this.tongueTwister,
  });

  @override
  State<PronunciationCoachView> createState() => _PronunciationCoachViewState();
}

class _PronunciationCoachViewState extends State<PronunciationCoachView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isRecording = false;
  String? _currentRecordingPath;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    if (_isRecording) {
      context.read<SlBloc>().add(StopRecording());
    } else {
      context.read<SlBloc>().add(StartRecording());
      _pulseController.repeat(reverse: true);
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  void _analyzeRecording() {
    if (_currentRecordingPath != null) {
      context.read<SlBloc>().add(
        AnalyzePronunciation(_currentRecordingPath!, widget.tongueTwister.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Coach'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<SlBloc, SlState>(
        listener: (context, state) {
          if (state is RecordingInProgress && !state.isRecording) {
            setState(() {
              _isRecording = false;
              _pulseController.stop();
              _pulseController.reset();
            });
          }
        },
        child: BlocBuilder<SlBloc, SlState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.tongueTwister.difficultyEmoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Chip(
                                label: Text(widget.tongueTwister.difficulty),
                                backgroundColor: _getDifficultyColor(
                                  widget.tongueTwister.difficulty,
                                ).withOpacity(0.2),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.tongueTwister.text,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.tongueTwister.translation.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.tongueTwister.translation,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: widget.tongueTwister.phonemes.map((phoneme) {
                              return Chip(
                                label: Text(phoneme),
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Recording Studio',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  WaveformVisualizer(
                    isRecording: _isRecording,
                    amplitude: 0.7,
                    waveColor: Theme.of(context).primaryColor,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isRecording ? _pulseAnimation.value : 1.0,
                              child: ElevatedButton.icon(
                                onPressed: _toggleRecording,
                                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                                label: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (!_isRecording && _currentRecordingPath != null) ...[
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _analyzeRecording,
                          icon: const Icon(Icons.analytics),
                          label: const Text('Analyze'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  if (state is PronunciationScoreLoaded)
                    PronunciationScoreCard(
                      score: state.score,
                      onRetry: () {
                        setState(() {
                          _currentRecordingPath = null;
                        });
                        _toggleRecording();
                      },
                    ),
                  
                  if (state is SlError)
                    Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.message,
                                style: TextStyle(color: Colors.red[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      case 'master':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
