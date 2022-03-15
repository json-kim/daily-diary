import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DrawerButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;
  final double? height;
  final double? width;

  const DrawerButton(
      {required this.title,
      required this.icon,
      required this.onTap,
      this.height,
      this.width,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height ?? 7.h,
        width: width ?? double.infinity,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(flex: 3, child: icon),
              Expanded(flex: 7, child: Text(title)),
            ],
          ),
        ),
      ),
    );
  }
}
