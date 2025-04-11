import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';

import 'package:virtual_toy_shop/presentation/all_toys/widgets/toy_3d_bottom_bar.dart';
import 'package:virtual_toy_shop/presentation/all_toys/widgets/toy_3d_panel.dart';
import 'package:virtual_toy_shop/widgets/3d_viewer/model_viewer_plus_mobile.dart';
import 'package:virtual_toy_shop/widgets/app_bars/simple_app_bar.dart';
import 'package:virtual_toy_shop/widgets/templates/no_connection.dart';

import '../../data/model/product.dart';

class Toy3D extends StatefulWidget {
  const Toy3D({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<Toy3D> createState() => _Toy3DState();
}

class _Toy3DState extends State<Toy3D> with SingleTickerProviderStateMixin {
  bool animationIsStarted = false;
  bool pause = true;
  final GlobalKey<ModelViewerState> modelViewerKey =
      GlobalKey<ModelViewerState>();
  bool isLoaded = false;

  double offset = 0;
  late Timer timer;
  int timeInThisScreen = 0;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(seconds: 1), (timer) => timeInThisScreen = timer.tick);
    controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        if (!isLoaded) {
          setState(() {
            offset = controller.value;
          });
        } else {
          setState(() {
            offset = 1;
            controller.stop();
          });
        }
      });

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    animation.removeListener(() {});
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToyDetailsCubit, ToyDetailsState>(builder: (context, state) {
      final toy = state.currentProduct;
      return !state.noConnection
          ? WillPopScope(
              onWillPop: () async {
                if(toy != null){
                  context.read<MainCubit>().sendAnalyticsEvent(
                      6,
                      seconds: timeInThisScreen,
                      id: toy.id
                  );
                }

                if (Platform.isAndroid) {
                  Navigator.pop(context);
                }
                return true;
              },
              child: Scaffold(
                body: !state.isLoading && toy != null
                    ? Column(
                        //fit: StackFit.expand,
                        children: [
                          Container(
                            color: MyColors.background,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).padding.top,
                          ),
                          Toy3DPanel(
                            toy: toy,
                            modelViewerKey: modelViewerKey,
                            isLoaded: isLoaded,
                            offset: offset,
                            onResetButtonTap: () {
                              setState(() {
                                pause = true;
                              });
                            },
                            onModelLoaded: () {
                              setState(() {
                                isLoaded = true;
                              });
                            },
                          ),
                          Toy3DBottomBar(
                            toy: toy,
                            title: widget.title,
                            paused: pause,
                            onPauseButtonTap: () {
                              if (isLoaded) {
                                setState(() {
                                  if (animationIsStarted) {
                                    if (pause) {
                                      modelViewerKey.currentState!.play();
                                    } else {
                                      modelViewerKey.currentState!.pause();
                                    }
                                    pause = !pause;
                                  } else {
                                    context
                                        .read<MainCubit>()
                                        .sendAnalyticsEvent(2, id: toy.id);
                                    modelViewerKey.currentState!.play();
                                    animationIsStarted = true;
                                    pause = false;
                                  }
                                });
                              }
                            },
                            onBackButtonTap: () {
                              context.read<MainCubit>().sendAnalyticsEvent(6,
                                  seconds: timeInThisScreen, id: toy.id);
                              Navigator.pop(context);
                            },
                          ),

                          /*if (!isLoaded)
                      Positioned(
                        bottom: 0,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 150,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: MyColors.orange,
                              ),
                            )),
                      ),
                    Positioned(
                        top: 20,
                        right: 20,
                        child: Row(
                          children: [
                            LikeButton(
                              toyId: toy.id ?? -1,
                              like: () {
                                context.read<MainCubit>().like(toy.id ?? -1);
                              },
                              dislike: () {
                                context.read<MainCubit>().dislike(toy.id ?? -1);
                              },
                              isSelected: toy.isLiked ?? false,
                              backgroundColor: MyColors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            WishlistButton(
                              toyId: toy.id ?? -1,
                              add: () {
                                context
                                    .read<MainCubit>()
                                    .addToWishlist(toy.id ?? -1);
                              },
                              remove: () {
                                context
                                    .read<MainCubit>()
                                    .removeFromWishlist(toy.id ?? -1);
                              },
                              isSelected: toy.isInUserProducts ?? false,
                              backgroundColor: MyColors.grey,
                            ),
                          ],
                        )),
                    if (!animationIsStarted && isLoaded)
                      Positioned(
                          top: 100,
                          right: 40,
                          child: Button3D(
                            action: () {
                              setState(() {
                                modelViewerKey.currentState!.play();
                                animationIsStarted = true;
                              });
                            },
                            baseSize: 110,
                            text1: "Tap to",
                            text2: "START",
                          )),
                    if (animationIsStarted)
                      Positioned(
                        bottom: 40,
                        right: MediaQuery.of(context).size.width / 2 - 220 / 2,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (pause) {
                                modelViewerKey.currentState!.play();
                              } else {
                                modelViewerKey.currentState!.pause();
                              }
                              pause = !pause;
                            });
                          },
                          child: Container(
                            width: 220,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                gradient: LinearGradient(
                                    end: Alignment.bottomCenter,
                                    begin: Alignment.topCenter,
                                    colors: [
                                      MyColors.lightBlue.withOpacity(0.8),
                                      MyColors.lightBlue.withOpacity(0.2),
                                    ])),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Image.asset(
                                    !pause
                                        ? "assets/icons/pause.png"
                                        : "assets/icons/play.png",
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )*/
                        ],
                      )
                    : const SizedBox(),
              ),
            )
          : Scaffold(
              appBar: SimpleAppBar(
                title: '',
              ),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 130.0),
                child: NoConnection(),
              ),
            );
    });
  }
}
