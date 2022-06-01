
part of 'state.dart';

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class _GlobalStateEvent{}

class SetFlexThemeIndexEvent extends _GlobalStateEvent{

  final int index;

  SetFlexThemeIndexEvent(this.index);

}

class SetThemeModeEvent extends _GlobalStateEvent{

  final ThemeMode mode;

  SetThemeModeEvent(this.mode);

}

class OpenAccountEvent extends _GlobalStateEvent{

  final Account account;

  OpenAccountEvent(this.account);

}

class AddTransactionToProjectedEvent extends _GlobalStateEvent{

  final Transaction transaction;

  AddTransactionToProjectedEvent(this.transaction);

}

class ApproveTransactionEvent extends _GlobalStateEvent{

  final Transaction transaction;

  ApproveTransactionEvent(this.transaction);

}

/*
 
      _        _   _                 
     / \   ___| |_(_) ___  _ __  ___ 
    / _ \ / __| __| |/ _ \| '_ \/ __|
   / ___ \ (__| |_| | (_) | | | \__ \
  /_/   \_\___|\__|_|\___/|_| |_|___/
                                     
 
*/

void wipeDataAction(Store<GlobalState> store) async {
  store.dispatch(SetState(GlobalState.initial()));
}

ThunkAction<GlobalState> addTransactionAction(Transaction transaction){
  return (Store<GlobalState> store) async {
    store.dispatch(AddTransactionToProjectedEvent(transaction));
    store.dispatch(ApproveTransactionEvent(transaction));
  };
}