import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/audio_provider.dart';
import 'package:radio/widgets/animated_gradient.dart';
import 'package:radio/widgets/player_controls.dart';
import 'package:radio/widgets/radio_button.dart';
import 'package:radio/widgets/social_links.dart';

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);

    return Scaffold(
        body: AnimatedGradientBackground(
      isPaused: !audioProvider.isPlaying,
      content: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: RadioButton(
                isPlaying: audioProvider.isPlaying,
                onPressed: audioProvider.togglePlay,
              ),
            ),
            const PlayerControls(),
            SocialLinks(),
          ],
        ),
      ),
    ));
  }
}
