import 'package:flutter/material.dart';
import 'package:phuonghai/constants/colors.dart';
import 'package:websafe_svg/websafe_svg.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.press,
    required this.text,
    required this.icon,
    this.isActived = false,
    this.lock = false,
    this.bgColor = AppColors.kBorderIconColor,
  }) : super(key: key);

  final bool isActived, lock;
  final String text, icon;
  final GestureTapCallback press;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 75,
      child: Column(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: press,
            splashColor: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 55,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: isActived
                          ? AppColors.kActiveIconColor.withOpacity(0.2)
                          : bgColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5.0,
                            spreadRadius: 3.0)
                      ]),
                  child: WebsafeSvg.asset(
                    icon,
                    color:
                        isActived ? AppColors.kActiveIconColor : Colors.black,
                  ),
                ),
                if (lock)
                  const Positioned(
                    bottom: 0,
                    left: 3,
                    child: Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
