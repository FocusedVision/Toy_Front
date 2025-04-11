import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';
import 'package:virtual_toy_shop/data/model/product.dart';
import 'package:virtual_toy_shop/presentation/all_toys/widgets/cube_loader.dart';
import 'package:virtual_toy_shop/presentation/all_toys/widgets/info_popup.dart';
import 'package:virtual_toy_shop/widgets/3d_viewer/model_viewer_plus.dart';
import 'package:virtual_toy_shop/widgets/3d_viewer/model_viewer_plus_mobile.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

class Toy3DPanel extends StatefulWidget {
  const Toy3DPanel({
    super.key,
    required this.toy,
    required this.modelViewerKey,
    required this.isLoaded,
    required this.offset,
    required this.onModelLoaded,
    required this.onResetButtonTap,
  });

  final Product toy;
  final bool isLoaded;
  final double offset;

  final GlobalKey<ModelViewerState> modelViewerKey;

  final VoidCallback onResetButtonTap;
  final VoidCallback onModelLoaded;

  @override
  State<Toy3DPanel> createState() => _Toy3DPanelState();
}

class _Toy3DPanelState extends State<Toy3DPanel> {
  bool isLoadedFakeDelay = false;
  bool infoOpened = false;

  bool userStartedInteraction = false;

  int get scaleValueInPercents => 150 - (widget.toy.defaultZoomLevel ?? 45);

  late final String? infoUrl;

  @override
  void initState() {
    if (widget.toy.hasInfoBlock) {
      infoUrl = context.read<ToyDetailsCubit>().getInfoUrl(widget.toy.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Stack(
      children: [
        SizedBox(
          height: screenSize.height -
              screenPadding.top -
              screenSize.height * 0.095 -
              screenSize.height * 0.11,
          child: widget.toy.background != null
              ? Transform.scale(
                  scale: 1.03,
                  child: Image.network(
                    widget.toy.background!,
                    width: screenSize.width,
                    fit: BoxFit.fill,
                  ),
                )
              : Image.asset(
                  'assets/background.png',
                  height: screenSize.height -
                      screenPadding.top -
                      screenSize.height * 0.095 -
                      screenSize.height * 0.1,
                  fit: BoxFit.fill,
                ),
        ),
        if (!widget.isLoaded)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.toy.image!,
              fit: BoxFit.fitWidth,
            ),
          ),
        if (!widget.isLoaded)
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.width,
            ),
          ),
        if (widget.toy.model != null)
          Positioned(
            bottom: 0,
            child: Listener(
              onPointerDown: (event) {
                if (widget.isLoaded && !userStartedInteraction) {
                  setState(() {
                    userStartedInteraction = true;
                  });
                }
              },
              child: SizedBox(
                width: screenSize.width,
                height: screenSize.height - 150,
                child: Transform.scale(
                  scale: 1.1,
                  child: ModelViewer(
                    onAnimationFinished: () {
                      context
                          .read<MainCubit>()
                          .sendAnalyticsEvent(3, id: widget.toy.id);
                    },
                    callBack: () {
                      context
                          .read<MainCubit>()
                          .sendAnalyticsEvent(1, id: widget.toy.id);
                      widget.onModelLoaded();
                      Timer.periodic(const Duration(milliseconds: 300),
                          (timer) {
                        setState(() {
                          isLoadedFakeDelay = true;
                        });
                        timer.cancel();
                      });
                    },
                    cameraOrbit: "0deg 75deg $scaleValueInPercents%",
                    maxCameraOrbit: "Infinity 157.5deg $scaleValueInPercents%",
                    key: widget.modelViewerKey,
                    src: widget.toy.model ?? '',
                    //interactionPrompt: InteractionPrompt.none,
                    autoRotate: true,
                    //autoPlay: true,
                    touchAction: TouchAction.none,
                    //reveal: Reveal.interaction,
                  ),
                ),
              ),
            ),
          ),
        if (widget.isLoaded)
          Positioned(
            top: 16,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: userStartedInteraction ? 0.0 : 0.8,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/pointer_scale.svg',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Zoom in and out with two fingers",
                        style: h6TextStyle.copyWith(color: MyColors.background),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (!widget.isLoaded)
          Positioned(
            top: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  color: Colors.grey.withOpacity(0.1),
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        if (widget.toy.brandImage != null)
          Positioned(
            bottom: 13,
            left: 13,
            child: SizedBox(
              width: screenSize.width * 0.20,
              child: CachedNetworkImage(
                imageUrl: widget.toy.brandImage!,
              ),
            ),
          ),
        if (!widget.isLoaded || !isLoadedFakeDelay)
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CubeLoader(
                  loadingOffset: widget.offset,
                ),
              ],
            ),
          ),
        Positioned(
          bottom: 8,
          right: 20,
          child: Column(
            children: [
              if (widget.isLoaded)
                InkWell(
                  onTap: () {
                    widget.modelViewerKey.currentState!.reset();
                    widget.onResetButtonTap();
                  },
                  child: Container(
                    height: screenSize.height * 0.065,
                    width: screenSize.height * 0.065,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Image.asset(
                      'assets/icons/reset.png',
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              if (widget.toy.hasInfoBlock)
                SizedBox(
                  height: (screenSize.height * 0.075) + 12,
                  width: screenSize.height * 0.075,
                ),
            ],
          ),
        ),
        if (widget.toy.hasInfoBlock)
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              reverseDuration: const Duration(milliseconds: 500),
              child: infoOpened
                  ? Stack(
                      children: [
                        InfoPopup(
                          url: infoUrl,
                          onClose: () {
                            setState(() {
                              infoOpened = false;
                            });
                          },
                        ),
                        Positioned(
                          top: 60 - 18,
                          right: 35 - 18,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                infoOpened = false;
                              });
                            },
                            child: SvgPicture.asset('assets/icons/close.svg'),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        if (widget.toy.hasInfoBlock && widget.isLoaded)
          Positioned(
            bottom: 8,
            right: 20,
            child: MainButton(
              onTap: () {
                setState(() {
                  infoOpened = !infoOpened;
                });
              },
              pressed: infoOpened,
              height: screenSize.height * 0.075,
              width: screenSize.height * 0.075,
              mainColor: MyColors.purpleLight,
              shadowColor: MyColors.purpleShadow,
              iconSize: 24,
              icon: "info_box",
              textSize: 12,
              label: "Info",
              isColumn: true,
            ),
          ),
      ],
    );
  }
}
