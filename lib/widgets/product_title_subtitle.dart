import 'package:flutter/material.dart';

class ProductTitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProductTitleSubtitle(this.title, this.subtitle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE
        Text(
          title,
          style: const TextStyle(fontSize: 20.0),
        ),
        const SizedBox(
          height: 6.0,
        ),

        // SUBTITLE
        Text(
          '\$$subtitle',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),

        // SPACING
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
