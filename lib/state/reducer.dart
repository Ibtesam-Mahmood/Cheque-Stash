
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
      themeFlexScheme: _themeFlexStateReducer(state, event),
      themeMode: _themeModeStateReducer(state, event),
      startDate: _startDateStateReducer(state, event),
      accounts: _accountStateReducer(state, event),
      budget: _budgetStateReducer(state, event),
      transactions: _transactionStateReducer(state, event),
      projectedTransactions: _projectedTransactionStateReducer(state, event),
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

int _themeFlexStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is SetFlexThemeIndexEvent){
    return event.index;
  }
  return state.themeFlexScheme;
}

ThemeMode _themeModeStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is SetThemeModeEvent){
    return event.mode;
  }
  return state.themeMode;
}

DateTime _startDateStateReducer(GlobalState state, _GlobalStateEvent event){
  return state.startDate;
}

List<Account> _accountStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is OpenAccountEvent){
    return [...state.accounts, event.account];
  }
  return state.accounts;
}

List<Transaction> _budgetStateReducer(GlobalState state, _GlobalStateEvent event){
  return state.budget;
}

List<Transaction> _transactionStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is ApproveTransactionEvent){
    final transactions = [...state.transactions];
    transactions.removeWhere((element) => element.id == event.transaction.id);
    transactions.add(event.transaction);
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }
  return state.transactions;
}

List<Transaction> _projectedTransactionStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is AddTransactionToProjectedEvent){
    final transactions = [...state.projectedTransactions];
    transactions.removeWhere((element) => element.id == event.transaction.id);
    transactions.add(event.transaction);
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }
  return state.projectedTransactions;
}