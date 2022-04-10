import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  const TopCard({
    required this.nettotal,
    required this.totalexpenses,
    required this.totalincome,
    Key? key,
  }) : super(key: key);
  final String nettotal;
  final String totalincome;
  final String totalexpenses;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.maxFinite,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(
                4,
                4,
              ),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BALANCE',
            style: TextStyle(
                color: Colors.grey[500],
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Text(
            '₦' + nettotal,
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text.rich(
                    TextSpan(
                        text: 'Income\n\n',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: '₦' + totalincome,
                          )
                        ]),
                  ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.arrow_downward,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text.rich(
                    TextSpan(
                        text: 'Expenses\n\n',
                        style: TextStyle(
                          color: Colors.grey[900],
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(
                            text: '₦' + totalexpenses,
                          )
                        ]),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
