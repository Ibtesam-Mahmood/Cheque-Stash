
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
      savedTypes: _savedTypesStateReducer(state, event),
      themeFlexScheme: _themeFlexStateReducer(state, event),
      themeMode: _themeModeStateReducer(state, event),
      startDate: _startDateStateReducer(state, event),
      lastComputedDate: _lastComputedDateStateReducer(state, event),
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

List<String> _savedTypesStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is AddSavedTypeEvent){
    return {event.type, ...state.savedTypes}.toList();
  }
  return state.savedTypes;
}

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
  if(event is _SetStartDateEvent){
    return event.start;
  }
  return state.startDate;
}

DateTime _lastComputedDateStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is _SetStartDateEvent){
    return event.start;
  }
  else if(event is _SetLastBudgetFromDateEvent){
    return event.date;
  }
  return state.lastComputedDate;
}

List<Account> _accountStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is OpenAccountEvent){
    return [...state.accounts, event.account];
  }
  return state.accounts;
}

List<Transaction> _budgetStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is AddTransactionEvent && event.destination == TransactionListType.budget){
    // Map all the transactions
    final transactions = state.budget.toMap<String>((t) => t.id);

    // add transaction
    transactions[event.transaction.id] = event.transaction;

    //sort and return
    final newTransactions = transactions.values.toList()..daySorted();
    return newTransactions;
  }
  else if(event is EditTransactionEvent && event.destination == TransactionListType.budget){
    // Map all the transactions
    final transactions = state.budget.toMap<String>((t) => t.id);

    // edit transaction
    if(transactions.containsKey(event.transaction.id)){
      transactions[event.transaction.id] = event.transaction;

      //sort and return
      final newTransactions = transactions.values.toList()..daySorted();
      return newTransactions;
    }
  }
  else if(event is DeleteTransactionEvent && event.destination == TransactionListType.budget){
    // Map all the transactions
    final transactions = state.budget.toMap<String>((t) => t.id);

    // delete transaction
    if(transactions.containsKey(event.transactionID)){
      transactions.remove(event.transactionID);

      //sort and return
      final newTransactions = transactions.values.toList()..daySorted();
      return newTransactions;
    }
  }
  else if(event is BatchAddTransactionListEvent && event.destination == TransactionListType.budget){
    // Map all the transactions
    final transactions = state.budget.toMap<String>((t) => t.id);

    // Add all
    transactions.addAll(event.transactions.toMap<String>((t) => t.id));

    //sort and return
    final newTransactions = transactions.values.toList()..dateSorted();
    return newTransactions;
  }
  return state.budget;
}

List<Transaction> _transactionStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is AddTransactionEvent && event.destination == TransactionListType.transactions){
    // Map all the transactions
    final transactions = state.transactions.toMap<String>((t) => t.id);

    // add transaction
    transactions[event.transaction.id] = event.transaction;

    //sort and return
    final newTransactions = transactions.values.toList()..dateSorted();
    return newTransactions;
  }
  else if(event is EditTransactionEvent && event.destination == TransactionListType.transactions){
    // Map all the transactions
    final transactions = state.transactions.toMap<String>((t) => t.id);

    // edit transaction
    if(transactions.containsKey(event.transaction.id)){
      transactions[event.transaction.id] = event.transaction;

      //sort and return
      final newTransactions = transactions.values.toList()..dateSorted();
      return newTransactions;
    }
  }
  else if(event is DeleteTransactionEvent && event.destination == TransactionListType.transactions){
    // Map all the transactions
    final transactions = state.transactions.toMap<String>((t) => t.id);

    // delete transaction
    if(transactions.containsKey(event.transactionID)){
      transactions.remove(event.transactionID);

      //sort and return
      final newTransactions = transactions.values.toList()..dateSorted();
      return newTransactions;
    }
  }
  else if(event is BatchAddTransactionListEvent && event.destination == TransactionListType.transactions){
    // Map all the transactions
    final transactions = state.transactions.toMap<String>((t) => t.id);

    // Add all
    transactions.addAll(event.transactions.toMap<String>((t) => t.id));

    //sort and return
    final newTransactions = transactions.values.toList()..dateSorted();
    return newTransactions;
  }
  return state.transactions;
}

List<Transaction> _projectedTransactionStateReducer(GlobalState state, _GlobalStateEvent event){
  if(event is _SetStartDateEvent){
    return [...state.projectedTransactions.where((element) => element.type == 'Initial Value')];
  }
  else if(event is AddTransactionEvent && event.destination == TransactionListType.projected){
    // Map all the transactions
    final transactions = state.projectedTransactions.toMap<String>((t) => t.id);

    // add transaction
    transactions[event.transaction.id] = event.transaction;

    //sort and return
    final newTransactions = transactions.values.toList()..dateSorted();
    return newTransactions;
  }
  else if(event is EditTransactionEvent && event.destination == TransactionListType.projected){
    // Map all the transactions
    final transactions = state.projectedTransactions.toMap<String>((t) => t.id);

    // edit transaction
    if(transactions.containsKey(event.transaction.id)){
      transactions[event.transaction.id] = event.transaction;

      //sort and return
      final newTransactions = transactions.values.toList()..dateSorted();
      return newTransactions;
    }
  }
  else if(event is DeleteTransactionEvent && event.destination == TransactionListType.projected){
    // Map all the transactions
    final transactions = state.projectedTransactions.toMap<String>((t) => t.id);

    // delete transaction
    if(transactions.containsKey(event.transactionID)){
      transactions.remove(event.transactionID);

      //sort and return
      final newTransactions = transactions.values.toList()..dateSorted();
      return newTransactions;
    }
  }
  else if(event is BatchAddTransactionListEvent && event.destination == TransactionListType.projected){
    // Map all the transactions
    final transactions = state.projectedTransactions.toMap<String>((t) => t.id);

    // Add all
    transactions.addAll(event.transactions.toMap<String>((t) => t.id));

    //sort and return
    final newTransactions = transactions.values.toList()..dateSorted();
    return newTransactions;
  }
  return state.projectedTransactions;
}