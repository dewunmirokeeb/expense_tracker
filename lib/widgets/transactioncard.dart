import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    required this.expenseorincome,
    required this.money,
    required this.transactionname,
    Key? key,
  }) : super(key: key);

  final String transactionname;
  final String money;
  final String expenseorincome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transactionname,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              Text(
                (expenseorincome == 'expense' ? '-' : '+') + ' ₦' + money,
                style: TextStyle(
                  color:
                      expenseorincome == 'expense' ? Colors.red : Colors.green,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
