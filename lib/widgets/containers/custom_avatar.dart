import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../config/my_colors.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    Key? key,
    required this.isSelected,
    required this.size,
    required this.image,
  }) : super(key: key);

  final bool isSelected;
  final double size;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size,
          width: size,
          padding: EdgeInsets.fromLTRB(size / 8, size / 8.8, size / 8, 0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: image != null ? SvgPicture.network(image!) : const SizedBox(),
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: GradientBoxBorder(
              gradient: LinearGradient(
                colors: isSelected
                    ? [
                        MyColors.greenShadow,
                        MyColors.greenLight,
                      ]
                    : [
                        MyColors.orangeShadow,
                        MyColors.orangeLight,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              width: size / 16,
            ),
          ),
        ),
      ],
    );
  }
}
