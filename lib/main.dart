//import 'dart:js';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([
    //DeviceOrientation.portraitUp,
    //DeviceOrientation.portraitDown,
  //]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        errorColor: Colors.red,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.amber),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold, 
            fontSize: 18
            ),
            labelLarge: TextStyle(
              color: Colors.white,
            ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //String? titleInput;
  //final titleController = TextEditingController();
  //final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
    /*Transaction(
      id: 't1', 
      title: 'New Shoes',
      amount: 69.99, 
      date: DateTime.now(),
      ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
      ),*/
  ];

bool _showChart = false;

List<Transaction> get _recentTransactions {
  return _userTransactions.where((tx) {
    return tx.date.isAfter(
      DateTime.now().subtract(
        Duration(days: 7),
      ),
    );
  }).toList();
}

void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
  final newTx = Transaction(
    title: txTitle, 
    amount: txAmount, 
    date: chosenDate,
    id: DateTime.now().toString(),
  );

  setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
      return GestureDetector(
        onTap: (){} ,
        child: NewTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    });
  }

  void _deleteTransaction (String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });;
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
        title: Text('Personal Expenses', 
        //style: TextStyle(fontFamily: 'OpenSans'),
        ),
        actions:<Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context),
            ),
        ]
      );
    final txListWidget = Container(
              height: (
                MediaQuery.of(context).size.height - 
                appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 
                0.70,
              //child: Expanded(
                child: TransactionList(_userTransactions,_deleteTransaction)
                );
    return Scaffold(
      appBar: appBar,
      body: ListView(
          //scrollDirection: Axis.vertical,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Show Chart'),
              Switch(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
                ),
            ],
            ),
            if (!isLandscape)
            Container(
              height: (
                MediaQuery.of(context).size.height - 
                appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 
                0.3,
              child: Chart(_recentTransactions),
              ),
              if (!isLandscape) txListWidget,
              if (isLandscape) _showChart ?
              Container(
              height: (
                MediaQuery.of(context).size.height - 
                appBar.preferredSize.height - MediaQuery.of(context).padding.top) * 
                0.7,
              child: Chart(_recentTransactions),
              ) : txListWidget
            //),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      );
    }
  }