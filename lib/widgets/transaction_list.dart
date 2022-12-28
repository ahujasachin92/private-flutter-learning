import 'package:flutter/material.dart';
//import 'package:flutter_expense_app/widgets/user_transactions.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

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
      : ListView.builder(
        itemBuilder: (ctx,index){
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30, 
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child:FittedBox(
                    child: 
                    Text('\$${transactions[index].amount}'),
                ),
              ),
              ),
              title: Text(
                transactions[index].title, 
                style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  DateFormat.yMMMd().format(transactions[index].date),
                ),
                trailing: MediaQuery.of(context).size.width > 460 ?
                TextButton.icon(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deleteTx(transactions[index].id), 
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).errorColor) 
                  ) :
                IconButton(
                  onPressed: () => deleteTx(transactions[index].id), 
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  ),
            ),
          );
      },
      itemCount: transactions.length,
                );
  }
}