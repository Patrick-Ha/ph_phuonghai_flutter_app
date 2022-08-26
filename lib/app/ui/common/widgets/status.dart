import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.error,
    required this.text,
  }) : super(key: key);

  final bool error;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        text.isEmpty
            ? const SizedBox.shrink()
            : Icon(
                error ? Icons.cancel_outlined : Icons.check_circle_outline,
                color: error ? Colors.red : Colors.green,
              ),
        const SizedBox(width: 8),
        Flexible(child: Text(text)),
      ],
    );
  }
}
