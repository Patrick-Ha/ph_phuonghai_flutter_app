import 'package:flutter/material.dart';
import 'package:phuonghai/constants/colors.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    this.press,
    this.bgColor = AppColors.kPrimaryColor,
    this.width = double.infinity,
  }) : super(key: key);
  final String text;
  final Color bgColor;
  final double width;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: bgColor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
