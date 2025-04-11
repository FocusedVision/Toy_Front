import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_toy_shop/config/get_it.dart';
import 'package:virtual_toy_shop/config/soundpool_manager.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';
import 'package:virtual_toy_shop/presentation/all_toys/toy_3d_screen.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';

import '../../data/model/product.dart';

class Toy extends StatefulWidget {
  const Toy({
    Key? key,
    required this.toyIndex,
    required this.isTileActive,
    required this.backgroundImage,
  }) : super(key: key);

  final int toyIndex;
  final bool isTileActive;
  final String backgroundImage;

  @override
  State<Toy> createState() => _ToyState();
}

class _ToyState extends State<Toy> {
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          Product toy = state.products![widget.toyIndex];
          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    goToToy(toy.id, toy.name ?? '');
                    getIt<SoundpoolManager>().play(soundName: "Button-open");
                  },
                  child: Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.96,
                        child: toy.background != null
                            ? CachedNetworkImage(
                                width: MediaQuery.of(context).size.width,
                                imageUrl: toy.gridImage!,
                                fit: BoxFit.fitWidth,
                              )
                            : Image.asset(
                                'assets/background.png',
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fitWidth,
                              ),
                      ),
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: toy.image!,
                          fit: BoxFit.fill,
                        ),
                      ),
                      if (toy.brandImage != null)
                        Positioned(
                          bottom: 13,
                          left: 13,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: CachedNetworkImage(
                              imageUrl: toy.brandImage!,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.017,
                    horizontal: 16,
                  ),
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          toy.name ?? '',
                          style: h4TextStyle.copyWith(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.019,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: MainButton(
                          onTap: () {
                            goToToy(toy.id, toy.name ?? '');
                          },
                          mainColor: MyColors.redLight,
                          shadowColor: MyColors.redShadow,
                          icon: "toy_hand",
                          label: "OPEN",
                          soundName: 'Button-open',
                          textSize: 20,
                          iconSize: 24,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void goToToy(int id, String name) {
    context.read<ToyDetailsCubit>().getToyById(id);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: Toy3D(title: name),
      ),
    );
  }
}
