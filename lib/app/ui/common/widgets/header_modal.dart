import 'package:flutter/material.dart';

class HeaderModal extends StatelessWidget {
  const HeaderModal({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        child: Row(
          children: [
            IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
