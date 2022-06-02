
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

class AddSavedTypeEvent extends _GlobalStateEvent{

  final String type;

  AddSavedTypeEvent(this.type);

}

class _SetStartDateEvent extends _GlobalStateEvent{

  final DateTime start;

  _SetStartDateEvent(this.start);

}

class _SetLastBudgetFromDateEvent extends _GlobalStateEvent{

  final DateTime date;

  _SetLastBudgetFromDateEvent(this.date);

}

class BatchAddTransactionListEvent extends _GlobalStateEvent{

  final TransactionListType destination;
  final List<Transaction> transactions;

  BatchAddTransactionListEvent(this.transactions) : destination = TransactionListType.transactions;
  BatchAddTransactionListEvent.budget(this.transactions) : destination = TransactionListType.budget;
  BatchAddTransactionListEvent.projected(this.transactions) : destination = TransactionListType.projected;
}

class AddTransactionEvent extends _GlobalStateEvent{

  final TransactionListType destination;
  final Transaction transaction;

  AddTransactionEvent({
    required this.destination,
    required this.transaction
  });

  AddTransactionEvent.transaction(this.transaction) : destination = TransactionListType.transactions;
  AddTransactionEvent.budget(this.transaction) : destination = TransactionListType.budget;
  AddTransactionEvent.projected(this.transaction) : destination = TransactionListType.projected;
}

class EditTransactionEvent extends _GlobalStateEvent{

  final TransactionListType destination;
  final Transaction transaction;

  EditTransactionEvent({
    required this.destination,
    required this.transaction
  });

  EditTransactionEvent.transaction(this.transaction) : destination = TransactionListType.transactions;
  EditTransactionEvent.budget(this.transaction) : destination = TransactionListType.budget;
  EditTransactionEvent.projected(this.transaction) : destination = TransactionListType.projected;
}

class DeleteTransactionEvent extends _GlobalStateEvent{
  
  final TransactionListType destination;
  final String transactionID;

  DeleteTransactionEvent({
    required this.destination,
    required this.transactionID
  });

  DeleteTransactionEvent.transaction(this.transactionID) : destination = TransactionListType.transactions;
  DeleteTransactionEvent.budget(this.transactionID) : destination = TransactionListType.budget;
  DeleteTransactionEvent.projected(this.transactionID) : destination = TransactionListType.projected;
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

ThunkAction<GlobalState> resetStartDateAction(DateTime date){
  return (Store<GlobalState> store) async {
    
    //Clear
    store.dispatch(_SetStartDateEvent(date));

    // Compute actions
    store.dispatch(computeBudgeSinceAction(date));
  };
}

ThunkAction<GlobalState> computeBudgeSinceAction(DateTime date){
  return (Store<GlobalState> store) async {
    
    final budgetMap = store.state.budget.toBudgetMap();

    // Compute budget
    List<Transaction> transactions = [];
    final now = DateTime.now();
    DateTime currentDay = date;

    while(now.compareTo(currentDay) >= 0){

      // Find and add transaction on day
      bool lastDay = currentDay.lastDayOfMonth.day == currentDay.day;
      final addedTransactions = [
        if(budgetMap[currentDay.day] != null)
          ...budgetMap[currentDay.day]!,
        if(lastDay && budgetMap[currentDay.day + 1] != null)
          ...budgetMap[currentDay.day + 1]!,
        if(lastDay && budgetMap[currentDay.day + 2] != null)
          ...budgetMap[currentDay.day + 2]!,
        if(lastDay && budgetMap[currentDay.day + 3] != null)
          ...budgetMap[currentDay.day + 3]!,
      ];

      for(var budget in addedTransactions){
        transactions.add(budget.recreateWith(
          date: currentDay,
        ));
      }

      currentDay = currentDay.add(const Duration(days: 1));
    }

    store.dispatch(BatchAddTransactionListEvent.projected(transactions));
    store.dispatch(_SetLastBudgetFromDateEvent(currentDay));
  };
}

ThunkAction<GlobalState> createInitialTransactionAction(Transaction transaction){
  return (Store<GlobalState> store) async {
    store.dispatch(AddTransactionEvent.projected(transaction));
    store.dispatch(AddTransactionEvent.transaction(transaction));
  };
}