import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key,
      required this.toyId,
      required this.like,
      required this.dislike,
      required this.isSelected
      }) : super(key: key);

  final int toyId;
  final Function like;
  final Function dislike;
  final bool isSelected;

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isSelected = widget.isSelected;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(listener: (context, state) {
      bool a = state.products!
          .firstWhere((element) => element.id == widget.toyId)
          .isLiked!;
      if (a != isSelected) {
        isSelected = a;
      }
    }, builder: (context, state) {
      return MainButton(
        onTap: () {
          animate();
          if (!isSelected) {
            widget.dislike();
          } else {
            widget.like();
          }
        },
        padding: const EdgeInsets.only(bottom: 5),
        mainColor: MyColors.redLight,
        shadowColor: MyColors.redShadow,
        iconSize: 28,
        icon: isSelected? "like_filled":"like",
      );
    });
  }

  void animate() async {
    setState(() {
      isSelected = !isSelected;
      // if (isSelected) {
      //   HapticFeedback.lightImpact(); // vibrate
      //   iconHeight = 15; // animate
      //   Future.delayed(const Duration(milliseconds: 200), () {
      //     setState(() {
      //       iconHeight = 20;
      //     });
      //   });
      // }
    });
  }
}
