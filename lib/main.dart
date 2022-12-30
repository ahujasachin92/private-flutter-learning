import 'dart:io';

import 'package:flutter/cupertino.dart';
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
            fontSize: 18,
            ),
            //button: TextStyle(color: Colors.white),
            //labelLarge: TextStyle(
              //color: Colors.black,
            //), 
        ),
        
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
        ),
        
        colorScheme: ColorScheme(
          brightness: Brightness.light, 
          primary: Colors.purple, 
          onPrimary: Colors.black, 
          secondary: Colors.amber, 
          onSecondary: Colors.amber, 
          error: Colors.red, 
          onError: Colors.red, 
          background: Colors.white, 
          onBackground: Colors.white, 
          surface: Colors.white, 
          onSurface: Colors.white)
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
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

@override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // TODO: implement initState
    super.initState();
  }

@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    //super.didChangeAppLifecycleState(state);
    print (state);
  }

  @override
  dispose () {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

List<Transaction> get _recentTransactions {
  return _userTransactions.where((tx) {
    return tx.date.isAfter(
      DateTime.now().subtract(
        Duration(days: 7),
      ),
    );
  }).toList();
}

void _addNewTransaction(
  String txTitle, double txAmount, DateTime chosenDate) {
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
    });
  }

  List<Widget> _buildLandscapeContent(
    MediaQueryData mediaQuery, 
    appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Show Chart', style: Theme.of(context).textTheme.titleMedium,),
              Switch.adaptive(
                activeColor: Theme.of(context).colorScheme.secondary,
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
                ),
            ],
            )
            ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQuery, 
    appBar,
    Widget txListWidget,
    ) {
    return [
      Container(
              height: (
                mediaQuery.size.height - 
                appBar.preferredSize.height - mediaQuery.padding.top) * 
                0.3,
              child: Chart(_recentTransactions),
              ),
              txListWidget,
    ];
  }

Widget _iOSNavigationBar() {
  return CupertinoNavigationBar(
      middle: const Text(
        'Personal Expenses',
        ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        GestureDetector(
          child: Icon(
            CupertinoIcons.add,
            color: Theme.of(context).colorScheme.onPrimary, 
            ),
          onTap: () => _startAddNewTransaction(context), 
          ),
      ],
      ),
    );
}

Widget _androidAppBar () {
  return AppBar(
        title: const Text('Personal Expenses', 
        //style: TextStyle(fontFamily: 'OpenSans'),
        ),
        actions: <Widget>[
          IconButton (
            icon: const Icon(
              Icons.add,
              //color: Theme.of(context).colorScheme.onPrimary,
              ),
            onPressed: () => _startAddNewTransaction(context),
            ),
        ],
      ) as PreferredSizeWidget;
}

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS 
    ? _iOSNavigationBar() as PreferredSizeWidget
    : _androidAppBar() as PreferredSizeWidget;
    
    final txListWidget = Container(
              height: (
                mediaQuery.size.height - 
                appBar.preferredSize.height - 
                mediaQuery.padding.top) * 
                0.70,
              //child: Expanded(
                child: TransactionList(_userTransactions,_deleteTransaction)
                );
    
    final pageBody = SafeArea (
      child: ListView(
          //scrollDirection: Axis.vertical,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            if (isLandscape) 
            ..._buildLandscapeContent(
              mediaQuery,
              appBar,
              txListWidget,
            ),
            if (!isLandscape) 
            ..._buildPortraitContent(
              mediaQuery, 
              appBar,
              txListWidget,
              ),
            if (!isLandscape) txListWidget,
            if (isLandscape) 
              _showChart 
              ?
              Container(
              height: (
                mediaQuery.size.height - 
                appBar.preferredSize.height - mediaQuery.padding.top) * 
                0.7,
              child: Chart(_recentTransactions),
              ) 
              : txListWidget]
            //),
      ),
        );
    
    return Platform.isIOS 
    ? CupertinoPageScaffold(
      child: pageBody, 
      navigationBar: appBar as ObstructingPreferredSizeWidget,
      ) 
      : 
      Scaffold(
      appBar: appBar,
      body: pageBody,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,
        floatingActionButton: Platform.isIOS ?
        Container () : FloatingActionButton
        (
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      );
    }
  }