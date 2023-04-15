import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    this.press,
    this.width = double.infinity,
    this.bgColor = Colors.green,
  }) : super(key: key);

  final Color bgColor;
  final String text;
  final double width;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 38,
      child: ElevatedButton(
        onPressed: press as void Function()?,
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: press == null ? Colors.black12 : bgColor,
        ),
        child: Text(text),
      ),
    );
  }
}
