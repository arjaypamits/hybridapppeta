import 'scene.dart';

/// Manages the current story state and all scene data.
///
/// Contains the complete branching story and handles navigation
/// between scenes based on player choices.
class StoryBrain {
  int _currentSceneIndex = 0;

  // ─────────────────────────────────────────
  //  COMPLETE STORY  (16 scenes, 3 endings)
  // ─────────────────────────────────────────
  static const List<Scene> _scenes = [
    // ── 0 ── MONDAY MORNING ─────────────────
    Scene(
      title: 'Monday Morning',
      storyText:
          'It is Monday — the first day of Finals Week.\n\n'
          'Your alarm goes off at 6:00 AM. The room is quiet. '
          'Your notes are sitting on the desk. '
          'You have a major exam tomorrow and a full day ahead of you.',
      choice1: 'Wake up early and start reviewing notes',
      choice2: 'Hit snooze and sleep 30 more minutes',
      nextScene1: 1,
      nextScene2: 2,
      imageName: 'morning.png',
    ),

    // ── 1 ── EARLY BIRD ──────────────────────
    Scene(
      title: 'Early Bird',
      storyText:
          'You get up early, brew some coffee, and open your notes. '
          'You feel calm and ahead of schedule. '
          'You still have time to get breakfast before your first class.',
      choice1: 'Eat a proper breakfast before class',
      choice2: 'Skip breakfast and keep studying',
      nextScene1: 3,
      nextScene2: 4,
      imageName: 'morning.png',
    ),

    // ── 2 ── SLEEPY START ────────────────────
    Scene(
      title: 'Sleepy Start',
      storyText:
          'You wake up late and feel groggy. '
          'The extra sleep did not help much — if anything, you feel worse. '
          'You only have 30 minutes before you need to leave.',
      choice1: 'Quickly grab something small to eat',
      choice2: 'Skip breakfast and rush straight to school',
      nextScene1: 4,
      nextScene2: 5,
      imageName: 'morning.png',
    ),

    // ── 3 ── FULL ENERGY ─────────────────────
    Scene(
      title: 'Full Energy',
      storyText:
          'You had a good breakfast and feel sharp and focused. '
          'You have the whole afternoon to study. '
          'This is the best you have felt all week. '
          'Now — how will you use your time?',
      choice1: 'Join a group study session with classmates',
      choice2: 'Study alone quietly in your room',
      nextScene1: 6,
      nextScene2: 7,
      imageName: 'study.png',
    ),

    // ── 4 ── LOW ENERGY ──────────────────────
    Scene(
      title: 'Running a Bit Low',
      storyText:
          'You feel a little off — maybe tired, maybe hungry — '
          'but you push through. You still have the afternoon to study. '
          'You need to choose how to spend it wisely.',
      choice1: 'Join a group study session',
      choice2: 'Study alone in your room',
      nextScene1: 6,
      nextScene2: 7,
      imageName: 'study.png',
    ),

    // ── 5 ── BURNED OUT ──────────────────────
    Scene(
      title: 'Running on Empty',
      storyText:
          'You arrive at school tired and hungry. '
          'You can barely concentrate during the morning review session. '
          'The material feels overwhelming and your notes look like a blur.',
      choice1: 'Take a short power nap in the afternoon',
      choice2: 'Push through and try to study anyway',
      nextScene1: 7,
      nextScene2: 8,
      imageName: 'study.png',
    ),

    // ── 6 ── GROUP STUDY ─────────────────────
    Scene(
      title: 'Group Study Session',
      storyText:
          'You meet up with classmates at the library. '
          'You explain topics to each other, share notes, and quiz one another. '
          'The session is very productive! Evening is approaching.',
      choice1: 'Go home and sleep early to rest for the exam',
      choice2: 'Stay up late gaming with friends instead',
      nextScene1: 9,
      nextScene2: 10,
      imageName: 'study.png',
    ),

    // ── 7 ── SOLO STUDY ──────────────────────
    Scene(
      title: 'Studying Solo',
      storyText:
          'You settle in quietly at your desk and work through the material '
          'at your own pace. It is productive. You cover most of the topics. '
          'The evening is here — time to make one last decision.',
      choice1: 'Go to bed early and get a full rest',
      choice2: 'Stay up late watching videos until 2 AM',
      nextScene1: 9,
      nextScene2: 10,
      imageName: 'study.png',
    ),

    // ── 8 ── LAST MINUTE PANIC ───────────────
    Scene(
      title: 'Last Minute Panic',
      storyText:
          'It is already evening and you have barely studied. '
          'Your notes are scattered. You are running on empty. '
          'The exam is tomorrow morning and you are not sure you can '
          'cover everything in one night.',
      choice1: 'Drink energy drinks and cram all night',
      choice2: 'Accept it, get some sleep, and hope for the best',
      nextScene1: 10,
      nextScene2: 11,
      imageName: 'study.png',
    ),

    // ── 9 ── READY FOR EXAM ──────────────────
    Scene(
      title: 'Exam Day Morning',
      storyText:
          'You slept well and wake up feeling refreshed. '
          'You feel calm and prepared. '
          'You do a quick final review of your notes over breakfast. '
          'The exam room is a short trip away.',
      choice1: 'Leave early and arrive at the exam room first',
      choice2: 'Stop for a snack on the way and arrive a bit late',
      nextScene1: 11,
      nextScene2: 12,
      imageName: 'exam.png',
    ),

    // ── 10 ── EXHAUSTED EXAM DAY ─────────────
    Scene(
      title: 'Exhausted Exam Day',
      storyText:
          'You barely slept. Your eyes are heavy and your head is foggy. '
          'You arrive at the exam still carrying yesterday\'s stress. '
          'The room is filling up with students who look far more ready than you.',
      choice1: 'Take a deep breath and focus as hard as you can',
      choice2: 'Zone out and guess most of the answers',
      nextScene1: 12,
      nextScene2: 15,
      imageName: 'exam.png',
    ),

    // ── 11 ── FOCUSED EXAM ───────────────────
    Scene(
      title: 'Exam Time — Focused',
      storyText:
          'You are in the exam room early. You read each question carefully '
          'and feel confident. Most of the material looks familiar from '
          'your studies. The room is quiet and your mind is clear.',
      choice1: 'Answer each question carefully, one at a time',
      choice2: 'Rush through everything to finish early',
      nextScene1: 13,
      nextScene2: 14,
      imageName: 'exam.png',
    ),

    // ── 12 ── STRUGGLING EXAM ────────────────
    Scene(
      title: 'Exam Time — Struggling',
      storyText:
          'You are in the exam room. Some questions look familiar, '
          'others do not. You feel uncertain but there is still time. '
          'How you handle the next few minutes could change everything.',
      choice1: 'Stay calm and think through each question slowly',
      choice2: 'Panic and rush through everything carelessly',
      nextScene1: 14,
      nextScene2: 15,
      imageName: 'exam.png',
    ),

    // ── 13 ── GOOD ENDING ────────────────────
    Scene(
      title: 'You Survived Finals Week!',
      storyText:
          'You passed all your exams with flying colors!\n\n'
          'Your hard work, healthy habits, and smart study strategies all '
          'paid off. Your professor even commended your performance in front '
          'of the class. You feel proud, relieved, and ready for a well-'
          'deserved break.\n\n'
          'You truly survived Finals Week.',
      isEnding: true,
      endingTitle: 'EXCELLENT RESULT',
      endingType: 'good',
      imageName: 'good_ending.png',
    ),

    // ── 14 ── NEUTRAL ENDING ─────────────────
    Scene(
      title: 'You Made It Through...',
      storyText:
          'You passed most of your subjects.\n\n'
          'Your performance was average — not perfect, but not a failure '
          'either. You could have done better, but you made it through '
          'Finals Week in one piece. You learned a few lessons about '
          'time management and preparation.\n\n'
          'There is always next semester.',
      isEnding: true,
      endingTitle: 'AVERAGE RESULT',
      endingType: 'neutral',
      imageName: 'neutral_ending.png',
    ),

    // ── 15 ── BAD ENDING ──────────────────────
    Scene(
      title: 'Finals Week Got You',
      storyText:
          'You failed your major exams.\n\n'
          'You were tired, unprepared, and overwhelmed. '
          'It was a really rough week. But remember — every failure is a '
          'lesson. Rest up, reflect on what went wrong, and come back '
          'stronger next semester.\n\n'
          'You will do better next time.',
      isEnding: true,
      endingTitle: 'FAILED',
      endingType: 'bad',
      imageName: 'bad_ending.png',
    ),
  ];

  // ─────────────────────────────────────────
  //  PUBLIC INTERFACE
  // ─────────────────────────────────────────

  int get currentSceneIndex => _currentSceneIndex;

  Scene get currentScene => _scenes[_currentSceneIndex];

  int get totalScenes => _scenes.length;

  /// Navigate to the next scene based on the player's choice (1 or 2).
  void makeChoice(int choiceNumber) {
    if (choiceNumber == 1) {
      _currentSceneIndex = currentScene.nextScene1;
    } else {
      _currentSceneIndex = currentScene.nextScene2;
    }
  }

  /// Reset to the beginning.
  void restart() {
    _currentSceneIndex = 0;
  }
}
