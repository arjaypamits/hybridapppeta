import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'story_brain.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SurviveFinalsApp());
}

// ──────────────────────────────────────────────────────────────
//  ROOT APP
// ──────────────────────────────────────────────────────────────

class SurviveFinalsApp extends StatelessWidget {
  const SurviveFinalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survive Finals Week',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 2,
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            elevation: 2,
          ),
        ),
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
      home: const StoryPage(),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  MAIN STORY PAGE  (StatefulWidget)
// ──────────────────────────────────────────────────────────────

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final StoryBrain _storyBrain = StoryBrain();
  final AudioPlayer _audioPlayer = AudioPlayer();

  // colour constants
  static const _navy = Color(0xFF1A237E);
  static const _indigo = Color(0xFF283593);
  static const _indigoLight = Color(0xFF3949AB);
  static const _bgColor = Color(0xFFEEF0FB);
  static const _textDark = Color(0xFF1A1A2E);

  // ending theme colours
  static const _goodColor = Color(0xFF1B5E20);
  static const _neutralColor = Color(0xFFE65100);
  static const _badColor = Color(0xFFB71C1C);

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  AUDIO HELPERS
  // ─────────────────────────────────────────

  Future<void> _playSound(String fileName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (_) {
      // Asset missing — continue silently
    }
  }

  // ─────────────────────────────────────────
  //  CHOICE HANDLER
  // ─────────────────────────────────────────

  void _handleChoice(int choice) {
    _playSound('click.wav');
    _storyBrain.makeChoice(choice);
    final scene = _storyBrain.currentScene;

    setState(() {});

    if (scene.isEnding) {
      final type = scene.endingType ?? 'neutral';
      if (type == 'good') {
        _playSound('success.wav');
      } else if (type == 'bad') {
        _playSound('fail.wav');
      } else {
        _playSound('neutral_end.wav');
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showEndingDialog();
      });
    }
  }

  // ─────────────────────────────────────────
  //  ENDING DIALOG
  // ─────────────────────────────────────────

  void _showEndingDialog() {
    final scene = _storyBrain.currentScene;
    final type = scene.endingType ?? 'neutral';

    Color headerColor;
    String badgeLabel;

    switch (type) {
      case 'good':
        headerColor = _goodColor;
        badgeLabel = 'PASSED';
      case 'bad':
        headerColor = _badColor;
        badgeLabel = 'FAILED';
      default:
        headerColor = _neutralColor;
        badgeLabel = 'AVERAGE';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: headerColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badgeLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scene.endingTitle ?? 'THE END',
                      style: TextStyle(
                        color: Colors.white.withAlpha(210),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              scene.storyText,
              style: const TextStyle(
                fontSize: 14,
                color: _textDark,
                height: 1.6,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: headerColor,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() => _storyBrain.restart());
                  },
                  child: const Text(
                    'PLAY AGAIN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final scene = _storyBrain.currentScene;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          'SURVIVE FINALS WEEK',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE BANNER
            SizedBox(
              width: double.infinity,
              height: size.height * 0.22,
              child: Image.asset(
                'assets/images/${scene.imageName}',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _PlaceholderBanner(
                  title: scene.title,
                  endingType: scene.endingType,
                ),
              ),
            ),

            // SCENE LABEL BAR
            Container(
              color: _indigo,
              padding: const EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 20,
              ),
              child: Text(
                scene.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // PROGRESS BAR
            LinearProgressIndicator(
              value: (_storyBrain.currentSceneIndex + 1) /
                  _storyBrain.totalScenes,
              backgroundColor: const Color(0xFFBBBEF6),
              valueColor: const AlwaysStoppedAnimation<Color>(_indigoLight),
              minHeight: 4,
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Story text card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Text(
                          scene.storyText,
                          style: const TextStyle(
                            fontSize: 15,
                            color: _textDark,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // CHOICE BUTTONS
                    if (!scene.isEnding) ...[
                      const _SectionLabel('WHAT WILL YOU DO?'),
                      const SizedBox(height: 12),
                      _ChoiceButton(
                        label: scene.choice1,
                        color: _navy,
                        onTap: () => _handleChoice(1),
                      ),
                      const SizedBox(height: 12),
                      _ChoiceButton(
                        label: scene.choice2,
                        color: _indigoLight,
                        onTap: () => _handleChoice(2),
                      ),
                    ] else ...[
                      Container(
                        color: _navy,
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 20,
                        ),
                        child: const Text(
                          'THE END\n\nYour result is shown above.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Scene counter
                    if (!scene.isEnding)
                      Row(
                        children: [
                          const Icon(
                            Icons.bookmark_outline,
                            size: 14,
                            color: _indigoLight,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Scene ${_storyBrain.currentSceneIndex + 1} of 16',
                            style: const TextStyle(
                              fontSize: 12,
                              color: _indigoLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  SMALL REUSABLE WIDGETS
// ──────────────────────────────────────────────────────────────

class _PlaceholderBanner extends StatelessWidget {
  const _PlaceholderBanner({required this.title, this.endingType});

  final String title;
  final String? endingType;

  Color get _color {
    switch (endingType) {
      case 'good':
        return const Color(0xFF1B5E20);
      case 'bad':
        return const Color(0xFFB71C1C);
      case 'neutral':
        return const Color(0xFFE65100);
      default:
        return const Color(0xFF283593);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      alignment: Alignment.center,
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Color(0xFF3949AB),
        fontWeight: FontWeight.w800,
        letterSpacing: 2,
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          elevation: 2,
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

