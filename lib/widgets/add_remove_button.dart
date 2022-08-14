import 'package:flutter/material.dart';

class AddRemoveButton extends StatelessWidget {
  final int quantity;
  const AddRemoveButton(this.quantity, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    return Container(
      height: 27.0,
      width: 75.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: Colors.yellow[900],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.remove_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
