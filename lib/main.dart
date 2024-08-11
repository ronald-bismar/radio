import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:radio/resources/Colores.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radio Filadelfia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Filadelfia Radio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool playRadio = false;
  bool muteRadio = false;
  String actualTime = "00:00";
  String totalTime = "00:00";
  String urlRadio = 'http://stream.zeno.fm/fd9bandxezzuv';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  updateButtons() {
    setState(() {
      playRadio = !playRadio;
      log("playRadio: $playRadio");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: title(),
          ),
          Align(alignment: Alignment.center, child: reproductor()),
          Align(alignment: Alignment.bottomCenter, child: parteBaja())
        ],
      ),
    );
  }

  Widget playOrPause() {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(2),
      onPressed: () => encenderRadio(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          playRadio ? Icons.pause : Icons.play_arrow,
          color: tertiary,
          key: ValueKey<bool>(playRadio),
        ),
      ),
    );
  }

  time(String actualTime, String totalTime) {
    return Text(
      "$actualTime/$totalTime",
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Colors.black,
        shadows: [
          Shadow(
            color: Colors.white,
            blurRadius: 10.0,
          ),
          Shadow(
            color: Colors.white,
            blurRadius: 12.0,
          ),
        ],
      ),
    );
  }

  lineTime() {
    double actual = 0.0;
    double total = 100.0;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: SliderComponentShape.noThumb,
        trackHeight: 3.0,
      ),
      child: Slider(
          value: actual,
          min: 0.0,
          max: total,
          onChanged: (value) {
            setState(() {
              total = value;
            });
          },
          activeColor: Colors.white,
          inactiveColor: tertiary),
    );
  }

  soundOrMute() {
    return IconButton(
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(2),
        onPressed: () => _setVolume(),
        icon: Icon(
          muteRadio ? Icons.volume_off : Icons.volume_up,
          color: tertiary,
        ));
  }

  options() {
    return const Icon(
      Icons.more_vert,
      color: Colors.black,
      size: 22.0,
    );
  }

  reproductor() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0), color: primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          playOrPause(),
          time(actualTime, totalTime),
          lineTime(),
          soundOrMute(),
          options()
        ],
      ),
    );
  }

  parteBaja() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          imageLink('assets/img/playstore.png', ''),
          imageLink('assets/img/insta.png', ''),
          imageLink('assets/img/what.png', ''),
          imageLink('assets/img/feis.png', ''),
          imageLink('assets/img/compa.png',
              ''), //En chrome no te pide toda la ruta solo desde la carpeta /img
        ],
      ),
    );
  }

  imageLink(String addressResource, String urlSocialMedia) {
    return GestureDetector(
      onTap: () => {},
      child: Image.asset(
        addressResource,
        height: 40,
        width: 40,
      ),
    );
  }

  title() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: const Text(
        "Filadelfia Radio",
        style: TextStyle(fontFamily: 'Sriracha', fontSize: 35),
      ),
    );
  }

  void _setVolume() {
    updateStateMute();
    if (muteRadio) {
      _audioPlayer.setVolume(0.0);
    } else {
      _audioPlayer.setVolume(1.0);
    }
  }

  void encenderRadio() async {
    updateButtons();
    if (!playRadio) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.setUrl(urlRadio);
      await _audioPlayer.play();
    }
  }

  void updateStateMute() {
    setState(() {
      muteRadio = !muteRadio;
    });
  }
}
