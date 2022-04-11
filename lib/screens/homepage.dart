import 'dart:async';

import 'package:expense_tracker/database/googlesheet.dart';
import 'package:expense_tracker/widgets/add.dart';
import 'package:expense_tracker/widgets/loadingcircle.dart';
import 'package:expense_tracker/widgets/topcard.dart';
import 'package:expense_tracker/widgets/transactioncard.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _amount = TextEditingController();
  TextEditingController _item = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _income = false;

  void _entertransaction() {
    GoogleSheetApi.insert(_item.text, _amount.text, _income);
    setState(() {});
  }

  void _newtransactions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('N E W - T R A N S A C T I O N')),
            content: Builder(builder: (context) {
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ToggleSwitch(
                      activeBgColor: const [Colors.green],
                      initialLabelIndex: 0,
                      totalSwitches: 2,
                      labels: const ['expense', 'income'],
                      onToggle: (index) {
                        if (index == 0) {
                          _income = false;
                        } else {
                          _income = true;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'For what',
                        ),
                        controller: _item,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Form(
                      key: _formkey,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Amount?',
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Enter an amount';
                          }
                          return null;
                        },
                        controller: _amount,
                      ),
                    ),
                  ],
                ),
              );
            }),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.grey[600],
                child: const Text(
                  'Cancel',
                ),
              ),
              MaterialButton(
                color: Colors.grey[600],
                child: const Text('Enter'),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _entertransaction();
                    _item.text = '';
                    _amount.text = '';
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  bool timmerhasstarted = false;
  void startloading() {
    timmerhasstarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetApi.loading == false) {
        setState(() {
          timer.cancel();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetApi.loading == true && timmerhasstarted == false) {
      startloading();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TopCard(
                  nettotal: GoogleSheetApi.balance().toString(),
                  totalexpenses: GoogleSheetApi.calculateexpense().toString(),
                  totalincome: GoogleSheetApi.calculateincome().toString(),
                ),
              ),
            ),
            Expanded(
              child: GoogleSheetApi.loading == true
                  ? const LoadingCircle()
                  : ListView.builder(
                      itemCount: GoogleSheetApi.currentTransaction.length,
                      itemBuilder: ((context, index) {
                        return TransactionCard(
                          transactionname:
                              GoogleSheetApi.currentTransaction[index][0],
                          money: GoogleSheetApi.currentTransaction[index][1],
                          expenseorincome:
                              GoogleSheetApi.currentTransaction[index][2],
                        );
                      }),
                    ),
            ),
            SizedBox(
              height: 50,
              child: AddButton(
                function: _newtransactions,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
