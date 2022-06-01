
part of 'state.dart';

/*
 
   _____                 _       
  | ____|_   _____ _ __ | |_ ___ 
  |  _| \ \ / / _ \ '_ \| __/ __|
  | |___ \ V /  __/ | | | |_\__ \
  |_____| \_/ \___|_| |_|\__|___/
                                 
 
*/

abstract class _GlobalStateEvent{

  static const String budget_destination = 'budget';
  static const String projected_destination = 'projected';
  static const String transaction_destination = 'transaction';

}

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

class AddSavedTypeEvent extends _GlobalStateEvent{

  final String type;

  AddSavedTypeEvent(this.type);

}

class EditTransactionEvent extends _GlobalStateEvent{

  final String destination;
  final Transaction transaction;

  EditTransactionEvent(this.transaction) : destination = _GlobalStateEvent.transaction_destination;
  EditTransactionEvent.budget(this.transaction) : destination = _GlobalStateEvent.budget_destination;
  EditTransactionEvent.projected(this.transaction) : destination = _GlobalStateEvent.projected_destination;
}

class DeleteTransactionEvent extends _GlobalStateEvent{
  
  final String destination;
  final String transactionID;

  DeleteTransactionEvent(this.transactionID) : destination = _GlobalStateEvent.transaction_destination;
  DeleteTransactionEvent.budget(this.transactionID) : destination = _GlobalStateEvent.budget_destination;
  DeleteTransactionEvent.projected(this.transactionID) : destination = _GlobalStateEvent.projected_destination;
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

ThunkAction<GlobalState> editTransactionAction(Transaction transaction, {bool inBudget = false}){
  return (Store<GlobalState> store) async {
    if(inBudget){
      store.dispatch(EditTransactionEvent.budget(transaction));
    }
    else{
      store.dispatch(EditTransactionEvent(transaction));
      store.dispatch(EditTransactionEvent.projected(transaction));
    }
  };
}

ThunkAction<GlobalState> deleteTransactionAction(Transaction transaction, {bool inBudget = false}){
  return (Store<GlobalState> store) async {
    if(inBudget){
      store.dispatch(DeleteTransactionEvent.budget(transaction.id));
    }
    else{
      store.dispatch(DeleteTransactionEvent(transaction.id));
      store.dispatch(DeleteTransactionEvent.projected(transaction.id));
    }
  };
}