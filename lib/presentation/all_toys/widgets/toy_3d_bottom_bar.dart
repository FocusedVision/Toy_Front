import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/data/model/product.dart';
import 'package:virtual_toy_shop/widgets/buttons/animated_buttons/like_button.dart';
import 'package:virtual_toy_shop/widgets/buttons/animated_buttons/wishlist_button.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

class Toy3DBottomBar extends StatelessWidget {
  const Toy3DBottomBar({
    super.key,
    required this.toy,
    required this.onBackButtonTap,
    required this.title,
    required this.onPauseButtonTap,
    required this.paused,
  });

  final Product toy;
  final String title;
  final bool paused;
  final VoidCallback onPauseButtonTap;
  final VoidCallback onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: MyColors.purple,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.095,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Flexible(
                flex: 1,
                child: MainButton(
                  onTap: onBackButtonTap,
                  mainColor: MyColors.purpleLight,
                  shadowColor: MyColors.purpleShadow,
                  iconSize: 24,
                  icon: "back",
                  textSize: 12,
                  label: "Back",
                  isColumn: true,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 3,
                child: MainButton(
                  onTap: onPauseButtonTap,
                  mainColor: MyColors.greenLight,
                  shadowColor: MyColors.greenShadow,
                  iconSize: 24,
                  icon: !paused ? "pause" : "play",
                  textSize: 20,
                  label: !paused ? "STOP" : "PLAY",
                  iconPadding: 4.0,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                flex: 1,
                child: MainButton(
                  onTap: () {
                    Uri url = Uri.parse(toy.externalLink ?? "");
                    launchUrl(url);
                  },
                  mainColor: MyColors.purpleLight,
                  shadowColor: MyColors.purpleShadow,
                  iconSize: 24,
                  icon: "web",
                  textSize: 12,
                  label: "More",
                  isColumn: true,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
        Container(
          color: MyColors.background,
          padding: const EdgeInsets.only(bottom: 15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.11,
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: h4TextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.019,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: LikeButton(
                  toyId: toy.id ?? -1,
                  like: () {
                    context.read<MainCubit>().like(toy.id ?? -1);
                  },
                  dislike: () {
                    context.read<MainCubit>().dislike(toy.id ?? -1);
                  },
                  isSelected: toy.isLiked ?? false,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: WishlistButton(
                  toyId: toy.id ?? -1,
                  add: () {
                    context.read<MainCubit>().addToWishlist(toy.id ?? -1);
                  },
                  remove: () {
                    context.read<MainCubit>().removeFromWishlist(toy.id ?? -1);
                  },
                  isSelected: toy.isInUserProducts ?? false,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
