import 'dart:async';

class StoryEventService {
  static final StreamController<void> _storyUpdatedController = StreamController<void>.broadcast();

  // Stream that other widgets can listen to
  static Stream<void> get onStoryUpdated => _storyUpdatedController.stream;

  // Call this when a story is saved
  static void notifyStoryUpdated() {
    _storyUpdatedController.add(null);
  }

  // Call this to clean up resources when app is disposed
  static void dispose() {
    _storyUpdatedController.close();
  }
} 