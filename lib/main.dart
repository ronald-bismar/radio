import 'package:flutter/material.dart';
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
  bool playRadio = true;
  bool muteRadio = false;
  String actualTime = "00:00";
  String totalTime = "00:00";

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

  Widget play() {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: const EdgeInsets.all(2),
      onPressed: () => setState(() => playRadio = !playRadio),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          playRadio ? Icons.pause : Icons.play_arrow,
          color: tertiary,
          size: 22.0,
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
            color: Colors.white, // Sombra adicional para mayor impacto
            blurRadius: 12.0,
          ),
        ],
      ),
    );
  }

  lineTime() {
    double currentSliderValue = 20.0;
    double totalDuration = 100.0;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: SliderComponentShape.noThumb,
        trackHeight: 3.0,
      ),
      child: Slider(
          value: currentSliderValue,
          min: 0.0,
          max: totalDuration,
          onChanged: (value) {
            setState(() {
              currentSliderValue = value;
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
        onPressed: () => setState(() => muteRadio = !muteRadio),
        icon: Icon(
          muteRadio ? Icons.volume_off : Icons.volume_up,
          color: tertiary,
          size: 22.0,
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
          borderRadius: BorderRadius.circular(50.0), color: colorExtra),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          play(),
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
          imageLink('img/playstore.png', ''),
          imageLink('img/insta.png', ''),
          imageLink('img/what.png', ''),
          imageLink('img/feis.png', ''),
          imageLink('img/compa.png', ''),
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
      padding: const EdgeInsets.all(30),
      child: const Text(
        "Filadelfia Radio",
        style: TextStyle(fontFamily: 'Sriracha', fontSize: 35),
      ),
    );
  }
}
