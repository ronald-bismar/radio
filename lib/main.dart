import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio/screens/home_page.dart';
import 'package:radio/providers/theme_provider.dart';
import 'package:radio/providers/audio_provider.dart';

void main() {
  runApp(
    Builder(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(context)),
          ChangeNotifierProvider(create: (_) => AudioProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Radio Filadelfia',
          theme: themeProvider.themeData,
          home: const HomePage(title: 'Filadelfia Radio'),
        );
      },
    );
  }
}
