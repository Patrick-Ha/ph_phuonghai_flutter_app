import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: Divider(
            color: Colors.black45,
            height: 0.8,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.5),
          ),
        ),
        const Expanded(
          child: Divider(
            height: 0.8,
            color: Colors.black45,
          ),
        ),
      ],
    );
  }
}
