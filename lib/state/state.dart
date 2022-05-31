import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

part 'event.dart';
part 'reducer.dart';

class GlobalState extends FortState<GlobalState>{

  final int themeFlexScheme;

  final ThemeMode themeMode;

  GlobalState({
    required this.themeFlexScheme,
    required this.themeMode,
  });

  factory GlobalState.initial() => GlobalState(
    themeFlexScheme: 0,
    themeMode: ThemeMode.light
  );

  factory GlobalState.fromJson(dynamic json){
    return GlobalState(
      themeFlexScheme: json['themeFlexScheme'],
      themeMode: ThemeMode.values[json['themeMode']]
    );
  }

  @override
  dynamic toJson() => {
    'themeFlexScheme': themeFlexScheme,
    'themeMode': themeMode.index
  };

  @override
  FortState<GlobalState> copyWith(FortState<GlobalState> other) {
    throw UnimplementedError();
  }

  static Tower<GlobalState> get tower => Tower<GlobalState>(
    _stateReducer,
    initialState: GlobalState.initial(),
    serializer: GlobalState.fromJson
  );

}