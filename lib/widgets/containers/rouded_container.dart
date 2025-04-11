import 'package:flutter/material.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {Key? key,
      this.height = 64,
      this.width = double.infinity,
      this.padding = EdgeInsets.zero,
      required this.child,
      this.color = MyColors.background})
      : super(key: key);

  final double height;
  final double width;
  final EdgeInsets padding;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 2, color: Colors.black),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: width,
          padding: padding,
          height: height - 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
