
part of 'state.dart';

/*
 
   ____          _                     
  |  _ \ ___  __| |_   _  ___ ___ _ __ 
  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
  |  _ <  __/ (_| | |_| | (_|  __/ |   
  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                       
 
*/

GlobalState _stateReducer(GlobalState state, dynamic event){
  if(event is _GlobalStateEvent){
    return GlobalState(
      themeFlexScheme: _themeFlexState(state, event),
      themeMode: _themeModeState(state, event),
    );
  }
  return state;
}

/*
 
   ____        _       ____          _                     
  / ___| _   _| |__   |  _ \ ___  __| |_   _  ___ ___ _ __ 
  \___ \| | | | '_ \  | |_) / _ \/ _` | | | |/ __/ _ \ '__|
   ___) | |_| | |_) | |  _ <  __/ (_| | |_| | (_|  __/ |   
  |____/ \__,_|_.__/  |_| \_\___|\__,_|\__,_|\___\___|_|   
                                                           
 
*/

int _themeFlexState(GlobalState state, _GlobalStateEvent event){
  if(event is SetFlexThemeIndexEvent){
    return event.index;
  }
  return state.themeFlexScheme;
}

ThemeMode _themeModeState(GlobalState state, _GlobalStateEvent event){
  if(event is SetThemeModeEvent){
    return event.mode;
  }
  return state.themeMode;
}