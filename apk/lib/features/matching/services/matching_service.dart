import 'package:dio/dio.dart';
import '../models/potential_match.dart';

class SwipeResult {
  final bool isMatch;
  final String? message;

  const SwipeResult({
    required this.isMatch,
    this.message,
  });
}

class MatchingService {
  final Dio _dio;

  MatchingService(this._dio);

  Future<List<PotentialMatch>> getPotentialMatches({
    String? language,
    int? minAge,
    int? maxAge,
    List<String>? interests,
  }) async {
    try {
      final response = await _dio.get('/api/v1/matching/discover', queryParameters: {
        if (language != null) 'language': language,
        if (minAge != null) 'min_age': minAge,
        if (maxAge != null) 'max_age': maxAge,
        if (interests != null) 'interests': interests.join(','),
      });

      final List<dynamic> data = response.data['data'];
      return data.map((json) => PotentialMatch.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockMatches();
    }
  }

  Future<SwipeResult> likeUser(int userId) async {
    try {
      final response = await _dio.post('/api/v1/matching/like', data: {
        'user_id': userId,
      });

      return SwipeResult(
        isMatch: response.data['is_match'] ?? false,
        message: response.data['message'],
      );
    } catch (e) {
      // Mock success for development
      return SwipeResult(
        isMatch: userId % 3 == 0, // Every 3rd user is a match for demo
        message: 'Mock like sent',
      );
    }
  }

  Future<void> passUser(int userId) async {
    try {
      await _dio.post('/api/v1/matching/pass', data: {
        'user_id': userId,
      });
    } catch (e) {
      // Mock success for development
      print('Mock: Passed user $userId');
    }
  }

  Future<SwipeResult> superLikeUser(int userId) async {
    try {
      final response = await _dio.post('/api/v1/matching/super-like', data: {
        'user_id': userId,
      });

      return SwipeResult(
        isMatch: response.data['is_match'] ?? false,
        message: response.data['message'],
      );
    } catch (e) {
      // Mock success for development
      return SwipeResult(
        isMatch: true, // Super likes always match for demo
        message: 'Super like sent!',
      );
    }
  }

  Future<void> undoSwipe(int userId) async {
    try {
      await _dio.post('/api/v1/matching/undo', data: {
        'user_id': userId,
      });
    } catch (e) {
      // Mock success for development
      print('Mock: Undid swipe for user $userId');
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      await _dio.post('/api/v1/matching/location', data: {
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      print('Mock: Updated location');
    }
  }

  List<PotentialMatch> _getMockMatches() {
    return [
      PotentialMatch(
        id: 1,
        username: "Maria Garcia",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=maria",
        bio: "Love learning languages and meeting new people!",
        interests: ["Languages", "Travel", "Music"],
        nativeLanguage: "Spanish",
        learningLanguage: "English",
        age: 24,
        location: "Madrid, Spain",
        compatibilityScore: 0.85,
        sharedInterests: ["Languages", "Travel"],
      ),
      PotentialMatch(
        id: 2,
        username: "Yuki Tanaka",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=yuki",
        bio: "Software developer passionate about Japanese culture",
        interests: ["Technology", "Anime", "Food"],
        nativeLanguage: "Japanese",
        learningLanguage: "English",
        age: 27,
        location: "Tokyo, Japan",
        compatibilityScore: 0.72,
        sharedInterests: ["Technology"],
      ),
      PotentialMatch(
        id: 3,
        username: "Jean Dupont",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=jean",
        bio: "Chef exploring the world one dish at a time",
        interests: ["Cooking", "Travel", "Languages"],
        nativeLanguage: "French",
        learningLanguage: "Spanish",
        age: 29,
        location: "Paris, France",
        compatibilityScore: 0.91,
        sharedInterests: ["Travel", "Languages"],
      ),
      PotentialMatch(
        id: 4,
        username: "Sophie Müller",
        avatar: "https://api.dicebear.com/7.x/avataaars/svg?seed=sophie",
        bio: "Music lover and language enthusiast",
        interests: ["Music", "Languages", "Reading"],
        nativeLanguage: "German",
        learningLanguage: "English",
        age: 23,
        location: "Berlin, Germany",
        compatibilityScore: 0.68,
        sharedInterests: ["Music"],
      ),
    ];
  }
}
