import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/story.dart';
import 'user_service.dart';
import 'story_event_service.dart';

class StoryStorageService {
  static const String _storiesKey = 'user_stories';

  // Save a story
  static Future<void> saveStory(Story story) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStoriesKey = await UserService.getUserStorageKey(_storiesKey);
      final existingStories = await getStories();
      
      // Add the new story to the list
      existingStories.add(story);
      
      // Convert to JSON and save with user-specific key
      final storiesJson = existingStories.map((s) => s.toJson()).toList();
      await prefs.setString(userStoriesKey, jsonEncode(storiesJson));
      
      // Notify that a story was updated
      StoryEventService.notifyStoryUpdated();
    } catch (e) {
      print('Error saving story: $e');
      rethrow;
    }
  }

  // Get all saved stories
  static Future<List<Story>> getStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStoriesKey = await UserService.getUserStorageKey(_storiesKey);
      final storiesJson = prefs.getString(userStoriesKey);
      
      if (storiesJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(storiesJson);
      return decoded.map((json) => Story.fromJson(json)).toList();
    } catch (e) {
      print('Error loading stories: $e');
      return [];
    }
  }

  // Delete a story
  static Future<void> deleteStory(String storyId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStoriesKey = await UserService.getUserStorageKey(_storiesKey);
      final stories = await getStories();
      
      // Remove the story with matching ID
      stories.removeWhere((story) => story.id == storyId);
      
      // Save updated list with user-specific key
      final storiesJson = stories.map((s) => s.toJson()).toList();
      await prefs.setString(userStoriesKey, jsonEncode(storiesJson));
    } catch (e) {
      print('Error deleting story: $e');
      rethrow;
    }
  }

  // Clear all stories
  static Future<void> clearAllStories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storiesKey);
    } catch (e) {
      print('Error clearing stories: $e');
      rethrow;
    }
  }
} 