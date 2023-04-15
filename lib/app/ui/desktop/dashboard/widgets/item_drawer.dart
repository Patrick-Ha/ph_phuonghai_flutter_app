import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  final bool isSelected;
  final Widget icon;
  final String text;
  final Function? press;
  final bool display;
  const ItemDrawer({
    Key? key,
    this.isSelected = false,
    required this.icon,
    required this.text,
    this.press,
    this.display = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return display
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.25) : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListTile(
              selected: isSelected,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              leading: icon,
              title: Text(text),
              onTap: press as void Function()?,
            ),
          )
        : const SizedBox.shrink();
  }
}
