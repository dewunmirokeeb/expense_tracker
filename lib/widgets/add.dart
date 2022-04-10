import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    required this.function,
    Key? key,
  }) : super(key: key);
  // ignore: prefer_typing_uninitialized_variables
  final function;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[500],
      radius: 90,
      child: Center(
        child: IconButton(
          onPressed: function,
          icon: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
