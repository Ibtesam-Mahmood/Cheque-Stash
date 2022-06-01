import 'package:cheque_stash/pages/home_page/home_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:tuple/tuple.dart';

void main() {
  runApp(const Budge8App());
}

class Budge8App extends StatefulWidget {
  const Budge8App({Key? key}) : super(key: key);

  @override
  State<Budge8App> createState() => _Budge8AppState();
}

class _Budge8AppState extends State<Budge8App> {

  final Tower<GlobalState> tower = GlobalState.tower;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: tower,
      child: StoreConnector<GlobalState, Tuple2<ThemeMode, int>>(
        converter: (store) => Tuple2(store.state.themeMode, store.state.themeFlexScheme),
        builder: (context, state) {

          final mode = state.item1;
          final themeIndex = state.item2;

          return MaterialApp(
            title: 'Budge-8',

            // Custom theme
            // theme: FlexThemeData.light(),
            // darkTheme: FlexThemeData.dark(),
            theme: FlexThemeData.light(
              scheme: FlexScheme.values[themeIndex],
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 20,
              appBarOpacity: 0.95,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                blendOnColors: false,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              // To use the playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.values[themeIndex],
              surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
              blendLevel: 15,
              appBarStyle: FlexAppBarStyle.background,
              appBarOpacity: 0.90,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 30,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              // To use the playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            themeMode: mode,
            home: HomePage()
          );
        }
      ),
    );
  }
}