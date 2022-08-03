import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final Color colorUser;
  final String text;
  const DividerWithText({
    Key? key,
    this.colorUser = const Color(0xff9e9e9e),
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(child: Divider(thickness: 1, color: colorUser)),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 8),
          constraints: const BoxConstraints(minWidth: 120),
          decoration: BoxDecoration(
            color: colorUser,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(child: Divider(thickness: 1, color: colorUser)),
        ),
      ],
    );
  }
}
