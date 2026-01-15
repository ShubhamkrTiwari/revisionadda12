import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String _subscriptionKey = 'is_subscribed';
  static const String _completedSetsKey = 'completed_mcq_sets';
  static const String _completedGamesKey = 'completed_games';
  static const int _freeSetsLimit = 2;
  static const int _freeGamesLimit = 1;

  // Check if user is subscribed
  static Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  // Set subscription status
  static Future<void> setSubscribed(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, value);
  }

  // Get completed sets count
  static Future<int> getCompletedSetsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final completedSets = prefs.getStringList(_completedSetsKey) ?? [];
    return completedSets.length;
  }

  // Check if a set is completed
  static Future<bool> isSetCompleted(String chapterId, int setNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final completedSets = prefs.getStringList(_completedSetsKey) ?? [];
    final setKey = '${chapterId}_set_$setNumber';
    return completedSets.contains(setKey);
  }

  // Mark a set as completed
  static Future<void> markSetCompleted(String chapterId, int setNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final completedSets = prefs.getStringList(_completedSetsKey) ?? [];
    final setKey = '${chapterId}_set_$setNumber';
    if (!completedSets.contains(setKey)) {
      completedSets.add(setKey);
      await prefs.setStringList(_completedSetsKey, completedSets);
    }
  }

  // Check if a set is locked
  static Future<bool> isSetLocked(String chapterId, int setNumber) async {
    final subscribed = await isSubscribed();
    if (subscribed) return false; // All sets unlocked if subscribed
    
    // First 2 sets are free, rest are locked
    return setNumber > _freeSetsLimit;
  }

  // Get free sets limit
  static int getFreeSetsLimit() => _freeSetsLimit;

  // Game-related methods
  // Get completed games count
  static Future<int> getCompletedGamesCount() async {
    final prefs = await SharedPreferences.getInstance();
    final completedGames = prefs.getStringList(_completedGamesKey) ?? [];
    return completedGames.length;
  }

  // Check if a game is completed
  static Future<bool> isGameCompleted(String subjectId, String gameType) async {
    final prefs = await SharedPreferences.getInstance();
    final completedGames = prefs.getStringList(_completedGamesKey) ?? [];
    final gameKey = '${subjectId}_${gameType}';
    return completedGames.contains(gameKey);
  }

  // Mark a game as completed
  static Future<void> markGameCompleted(String subjectId, String gameType) async {
    final prefs = await SharedPreferences.getInstance();
    final completedGames = prefs.getStringList(_completedGamesKey) ?? [];
    final gameKey = '${subjectId}_${gameType}';
    if (!completedGames.contains(gameKey)) {
      completedGames.add(gameKey);
      await prefs.setStringList(_completedGamesKey, completedGames);
    }
  }

  // Check if a game is locked
  static Future<bool> isGameLocked(String subjectId, String gameType) async {
    final subscribed = await isSubscribed();
    if (subscribed) return false; // All games unlocked if subscribed
    
    final completedGames = await getCompletedGamesCount();
    return completedGames >= _freeGamesLimit;
  }

  // Get free games limit
  static int getFreeGamesLimit() => _freeGamesLimit;
}
