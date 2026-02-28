import 'dart:io';
import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../models/tongue_twister.dart';
import '../models/pronunciation_score.dart';
import '../models/leaderboard_entry.dart';

class SlService {
  final Dio _dio;
  final AudioRecorder _audioRecorder;

  SlService(this._dio) : _audioRecorder = AudioRecorder();

  Future<List<TongueTwister>> getTongueTwisters() async {
    try {
      final response = await _dio.get('/api/v1/sl/tongue-twisters');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => TongueTwister.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockTongueTwisters();
    }
  }

  Future<void> startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
      
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: path,
      );
    } catch (e) {
      throw Exception('Failed to start recording: $e');
    }
  }

  Future<String> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path == null) {
        throw Exception('Recording failed to save');
      }
      return path;
    } catch (e) {
      throw Exception('Failed to stop recording: $e');
    }
  }

  Future<PronunciationScore> analyzePronunciation(
    String audioPath,
    String targetText,
  ) async {
    try {
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioPath),
        'target_text': targetText,
      });

      final response = await _dio.post(
        '/api/v1/sl/analyze-pronunciation',
        data: formData,
      );

      return PronunciationScore.fromJson(response.data['data']);
    } catch (e) {
      // Return mock score for development
      return _getMockPronunciationScore(audioPath);
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      final response = await _dio.get('/api/v1/sl/leaderboard');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => LeaderboardEntry.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockLeaderboard();
    }
  }

  Future<void> unlockTongueTwister(int twisterId) async {
    try {
      await _dio.post('/api/v1/sl/tongue-twisters/$twisterId/unlock');
    } catch (e) {
      // Mock success for development
      print('Mock: Unlocked tongue twister $twisterId');
    }
  }

  Future<void> saveScore(int twisterId, int score) async {
    try {
      await _dio.post(
        '/api/v1/sl/tongue-twisters/$twisterId/score',
        data: {'score': score},
      );
    } catch (e) {
      // Mock success for development
      print('Mock: Saved score $score for twister $twisterId');
    }
  }

  List<TongueTwister> _getMockTongueTwisters() {
    return [
      TongueTwister(
        id: 1,
        text: "She sells seashells by the seashore",
        language: "English",
        difficulty: "Easy",
        translation: "Ella vende conchas marinas en la orilla del mar",
        phonemes: ["ʃ", "s", "ɛ", "l"],
        isUnlocked: true,
        bestScore: 85,
      ),
      TongueTwister(
        id: 2,
        text: "Peter Piper picked a peck of pickled peppers",
        language: "English",
        difficulty: "Medium",
        translation: "Pedro Pérez piquó un pepinero de pimientos encurtidos",
        phonemes: ["p", "i", "e", "r"],
        isUnlocked: true,
        bestScore: null,
      ),
      TongueTwister(
        id: 3,
        text: "How much wood would a woodchuck chuck",
        language: "English",
        difficulty: "Hard",
        translation: "Cuánta madera tiraría una marmota",
        phonemes: ["w", "ʊ", "d", "tʃ"],
        isUnlocked: false,
        bestScore: null,
      ),
      TongueTwister(
        id: 4,
        text: "The sixth sick sheikh's sixth sheep's sick",
        language: "English",
        difficulty: "Master",
        translation: "El sexto enfermo del sexto jeque está enfermo",
        phonemes: ["s", "ɪ", "k", "ʃ"],
        isUnlocked: false,
        bestScore: null,
      ),
    ];
  }

  PronunciationScore _getMockPronunciationScore(String audioPath) {
    return PronunciationScore(
      overallScore: 78.5,
      phonemeScores: {
        "ʃ": 85.0,
        "s": 92.0,
        "ɛ": 75.0,
        "l": 62.0,
      },
      feedback: [
        "Good pronunciation of 's' sounds",
        "Work on your 'l' articulation",
        "Try to emphasize the 'sh' sound more",
      ],
      recordingPath: audioPath,
      timestamp: DateTime.now(),
    );
  }

  List<LeaderboardEntry> _getMockLeaderboard() {
    return [
      LeaderboardEntry(
        id: 1,
        username: "Sarah Chen",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=sarah",
        score: 98,
        tongueTwisterText: "She sells seashells by the seashore",
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        rank: 1,
      ),
      LeaderboardEntry(
        id: 2,
        username: "Mike Johnson",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=mike",
        score: 95,
        tongueTwisterText: "She sells seashells by the seashore",
        completedAt: DateTime.now().subtract(const Duration(hours: 5)),
        rank: 2,
      ),
      LeaderboardEntry(
        id: 3,
        username: "Emma Wilson",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=emma",
        score: 92,
        tongueTwisterText: "Peter Piper picked a peck of pickled peppers",
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        rank: 3,
      ),
    ];
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
