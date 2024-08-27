import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isMuted = false;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  Duration get elapsedTime => _elapsedTime;

  static const String _url = 'http://stream.zeno.fm/fd9bandxezzuv';

  AudioProvider() {
    _audioPlayer.setUrl(_url);
    _monitorConnectivity();
  }

  Future togglePlay() async {
    _isPlaying = !_isPlaying;
    notifyListeners();
    if (!_isPlaying) {
      _stopTimer();
      await _audioPlayer.stop();
    } else {
      _startTimer();
      await _audioPlayer.play();
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioPlayer.setVolume(_isMuted ? 0.0 : 1.0);
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_isPlaying) {
        _elapsedTime += const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    _elapsedTime = Duration.zero;
    notifyListeners();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        if (result != ConnectivityResult.none && _isPlaying) {
          try {
            await _audioPlayer.play();
          } catch (e) {
            // Manejar el error de reconexión
            log('Error al intentar reconectar: $e');
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _stopTimer();
    _connectivitySubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
