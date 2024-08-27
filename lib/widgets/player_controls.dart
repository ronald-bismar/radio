import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/providers/audio_provider.dart';
import 'package:radio/providers/theme_provider.dart';
import 'package:radio/resources/colores.dart';
import 'package:radio/widgets/bar_progress_indicator.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      decoration: BoxDecoration(
        color: themeProvider.colorReproductor,
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [
          BoxShadow(
            color: themeProvider.shadowDark,
            offset: const Offset(3, 3),
            blurRadius: 15,
          ),
          BoxShadow(
            color: themeProvider.shadowLight,
            offset: const Offset(-3, -3),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayPauseButton(audioProvider),
          _buildTimeDisplay(audioProvider),
          Expanded(
            child: CustomLinearProgressIndicator(
              playRadio: !audioProvider.isPlaying,
            ),
          ),
          _buildMuteButton(audioProvider),
          _buildOptionsButton(context, themeProvider),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton(AudioProvider audioProvider) {
    return IconButton(
      onPressed: audioProvider.togglePlay,
      icon: Icon(
        audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTimeDisplay(AudioProvider audioProvider) {
    return Text(
      "${_formatDuration(audioProvider.elapsedTime)}/00:00",
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildMuteButton(AudioProvider audioProvider) {
    return IconButton(
      onPressed: audioProvider.toggleMute,
      icon: Icon(
        audioProvider.isMuted ? Icons.volume_off : Icons.volume_up,
        color: Colors.white,
      ),
    );
  }

  Widget _buildOptionsButton(
      BuildContext context, ThemeProvider themeProvider) {
    return IconButton(
      onPressed: () => _showOptionsMenu(context, themeProvider),
      icon: const Icon(Icons.more_vert, color: Colors.white),
    );
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _showOptionsMenu(BuildContext context, ThemeProvider themeProvider) {
    final isDarkMode = themeProvider.isDarkMode;
    final textColor = isDarkMode ? colorExtra : Colors.white70;
    final backgroundColor = isDarkMode ? Colors.white10 : colorExtra;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.brightness_4, color: textColor),
                title: Text(isDarkMode ? 'Modo Claro' : 'Modo Oscuro'),
                textColor: textColor,
                onTap: () {
                  Navigator.pop(context);
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
