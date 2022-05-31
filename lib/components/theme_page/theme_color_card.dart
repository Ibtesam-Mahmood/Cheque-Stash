
import 'dart:ui';

import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:tuple/tuple.dart';

class ThemeColorCard extends StatefulWidget {

  final FlexScheme scheme;

  const ThemeColorCard({Key? key, required this.scheme}) : super(key: key);

  @override
  State<ThemeColorCard> createState() => _ThemeColorCardState();
}

class _ThemeColorCardState extends State<ThemeColorCard> {

  bool hover = false;

  ThemeData get _lightTheme => FlexThemeData.light(scheme: widget.scheme);
  ThemeData get _darkTheme => FlexThemeData.dark(scheme: widget.scheme);

  Brightness _currentThemeBrightness(ThemeMode mode){
    switch (mode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      default:
        return WidgetsBinding.instance.window.platformBrightness;
    }
  }

  ThemeData _currentTheme(Brightness brightness){
    if(brightness == Brightness.light){
      return _lightTheme;
    }
    else{
      return _darkTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_){
        setState(() {
          hover = true;
        });
      },
      onTapCancel: (){
        setState(() {
          hover = false;
        });
      },
      onTapUp: (_){
        setState(() {
          hover = false;
        });
        StoreProvider.of<GlobalState>(context).dispatch(SetFlexThemeIndexEvent(widget.scheme.index));
      },
      child: StoreConnector<GlobalState, Tuple2<ThemeMode, int>>(
        converter: (store) => Tuple2(store.state.themeMode, store.state.themeFlexScheme),
        builder: (context, state) {

          final brightness = _currentThemeBrightness(state.item1);
          final theme = _currentTheme(brightness);
          final selected = hover || widget.scheme.index == state.item2;

          return TweenAnimationBuilder<BorderRadius>(
            curve: Constants.DEFAULT_CURVE,
            duration: Constants.DEFAULT_DURATION,
            tween: Tween(begin: Constants.DEFAULT_RADIUS, end: selected ? Constants.DEFAULT_RADIUS : Constants.SQUARE_RADIUS),
            builder: (context, value, child){

              final animation = (value.topLeft.x - Constants.SQUARE_RADIUS.topLeft.x) / (Constants.DEFAULT_RADIUS.topLeft.x - Constants.SQUARE_RADIUS.topLeft.x);
              
              return Container(
                padding: EdgeInsets.all(
                  lerpDouble(0, 5, animation)!
                ),
                decoration: BoxDecoration(
                  borderRadius: Constants.DEFAULT_RADIUS,
                  color: Color.lerp(Colors.transparent, theme.primaryColorDark, animation)
                ),
                child: ClipRRect(
                  borderRadius: value,
                  child: child
                ),
              );
            },
            child: Container(
              height: 100,
              width: 100,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: theme.colorScheme.primaryContainer,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: theme.colorScheme.secondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}