/// Represents a single story scene (page) in the adventure.
///
/// Each scene has story text, up to two choices, and metadata
/// about where each choice leads. Ending scenes have no choices.
class Scene {
  final String title;
  final String storyText;
  final String choice1;
  final String choice2;
  final int nextScene1;
  final int nextScene2;
  final bool isEnding;
  final String? endingTitle;

  /// 'good' | 'neutral' | 'bad'
  final String? endingType;
  final String imageName;

  const Scene({
    required this.title,
    required this.storyText,
    this.choice1 = '',
    this.choice2 = '',
    this.nextScene1 = -1,
    this.nextScene2 = -1,
    this.isEnding = false,
    this.endingTitle,
    this.endingType,
    this.imageName = 'morning.png',
  });
}
