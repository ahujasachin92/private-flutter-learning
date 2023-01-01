import 'package:flutter/material.dart';
//import 'package:flutter_expense_app/widgets/user_transactions.dart';
import '../models/transaction.dart';
import './transaction_item.dart';
//import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty? 
    LayoutBuilder(builder: (ctx, constraints) {
      return Column(children: <Widget> [
        Text('No transactions added yet!',
        style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height:20),
        Container(
          height:constraints.maxHeight * 0.6,
          child: Image.asset('assets/images/waiting.png', 
          fit: BoxFit.cover,))
      ],
      );
    }) 
      : ListView (
        children: transactions
        .map((tx) => TransactionItem(
          key: ValueKey(tx.id),
          transaction: tx,
          deleteTx: deleteTx,
          )
          ).toList(),
      );
  }
}

