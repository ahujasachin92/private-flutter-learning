import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';
//import 'package:flutter_expense_app/widgets/user_transactions.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

 const NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); 

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
      //print ('hello!');
    }
    widget.addTx(
      enteredTitle, 
      enteredAmount,
      _selectedDate,
      );
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2019), 
      lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate == null) 
        {
        return;
        }
        setState(() {
          _selectedDate = pickedDate;
          });
        });
      print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
              elevation: 5.0,
              child: 
            Container(
              padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children:<Widget>[
                  
                  TextField(
                    decoration: InputDecoration(labelText: 'Title'),
                    controller: _titleController,
                    onSubmitted: (_) => _submitData(),
                    //onChanged: (val) {
                    //  titleInput = val;
                    //},
                    ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData(),
                    //onChanged: (val) => amountInput = val,
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null 
                            ? 'No chosen date!'
                            : DateFormat.yMd().format(_selectedDate),
                            ),
                        ),
                        AdaptiveFlatButton('Choose date', _presentDatePicker)
                      ],
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Add transaction', 
                      //style: Theme.of(context).textTheme.titleSmall,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      ), 
                    //style: ElevatedButton.styleFrom(
                      //foregroundColor: Colors.white,
                      //backgroundColor: Colors.purple,
                    //),
                    onPressed: _submitData,
                    //() { 
                      //addTx(
                        //titleController.text, 
                        //double.parse(amountController.text),
                  ),
                      //print(titleController.text);
                      //print(amountController.text);
                    //),
                ],
              ),
            ),
      ),
    );
  }
}