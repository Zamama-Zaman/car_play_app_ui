// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:car_play_app/presentation/state_management/asset_audio_player_provider.dart';
import 'package:car_play_app/presentation/state_management/audio_player_provider.dart';
import 'package:car_play_app/presentation/state_management/show_search_bar_provider.dart';
import 'package:car_play_app/presentation/state_management/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  Future.delayed(
      Duration(
        seconds: 5,
      ), () {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AssetAudioPlayerProvider()),
          ChangeNotifierProvider(create: (_) => ShowSearchBarProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Car Play",
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        // primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black87,
        colorScheme: ColorScheme.dark(
          surface: Colors.red,
          // secondary: Colors.red,
          // background: Colors.red,
          // brightness: Colors.red,
          // error: Colors.red,
          // onBackground: Colors.red,
          // onError: Colors.red,
          // onPrimary: Colors.red,
          // onSecondary: Colors.red,
          // onSurface: Colors.red,
          primary: Colors.red,
          // primaryVariant: Colors.red,
          // secondaryVariant: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
