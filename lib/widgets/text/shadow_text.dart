import 'package:flutter/material.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';

class ShadowText extends StatelessWidget {
  const ShadowText({
    Key? key,
    this.size = 17.0,
    this.shadowColor = Colors.black,
    this.textColor = MyColors.darkYellow,
    this.textAlign = TextAlign.center,
    this.offset = const Offset(0, -1),
    required this.text,
  }) : super(key: key);

  final Color textColor;
  final Color shadowColor;
  final double size;
  final String text;
  final TextAlign textAlign;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: textColor,
        shadows: [
          Shadow(
            offset: offset,
            color: shadowColor,
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
