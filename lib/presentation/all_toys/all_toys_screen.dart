import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:soundpool/soundpool.dart';
import 'package:virtual_toy_shop/config/get_it.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/soundpool_manager.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';
import 'package:virtual_toy_shop/presentation/all_toys/toy_3d_screen.dart';
import 'package:virtual_toy_shop/widgets/3d_viewer/toy.dart';
import 'package:virtual_toy_shop/widgets/app_bars/main_app_bar.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

import '../../data/model/product.dart';

class AllToysScreen extends StatefulWidget {
  const AllToysScreen({Key? key}) : super(key: key);

  @override
  _AllToysScreenState createState() => _AllToysScreenState();
}

class _AllToysScreenState extends State<AllToysScreen> {
  bool isTileActive = false;
  ScrollController scrollController = ScrollController();
  bool isLoading = false; // pagination loading

  @override
  void initState() {
    scrollController = ScrollController()..addListener(scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: MainAppBar(
          label: 'All Toys',
          titleIcon: "blocks",
          action: switchButton(),
        ),
        body: state.products != null
            ? RefreshIndicator(
                displacement: kToolbarHeight + 70,
                backgroundColor: MyColors.background,
                color: MyColors.orangeShadow,
                strokeWidth: 3,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: () async {
                  HapticFeedback.lightImpact();
                  await context.read<MainCubit>().getProducts(1);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Scrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(7),
                    thickness: 7,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: context.read<MainCubit>().isFeedOpened()
                          ? feed(state)
                          : grid(state),
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: MyColors.greenShadow,
                ),
              ),
      );
    });
  }

  MainButton switchButton() {
    return MainButton(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
      height: MediaQuery.of(context).size.height * 0.047,
      width: MediaQuery.of(context).size.height * 0.047,
      onTap: () {
        context.read<MainCubit>().changeToyScreenState();
      },
      icon: context.read<MainCubit>().isFeedOpened() ? 'grid' : 'feed',
      shadowColor: MyColors.greenShadow,
      mainColor: MyColors.greenLight,
      iconColor: Colors.black,
    );
  }

  Column feed(MainState state) {
    return Column(
      children: [
        const SizedBox(
          height: kToolbarHeight + 35,
        ),
        ...List.generate(state.products?.length ?? 0, (index) {
          return Toy(
            toyIndex: index,
            isTileActive: isTileActive,
            backgroundImage: state.products?[index].background ?? '',
          );
        }),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget grid(MainState state) {
    return Column(
      children: [
        const SizedBox(
          height: kToolbarHeight + 55,
        ),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          children: List.generate(state.products?.length ?? 0, (index) {
            Product currentToy = state.products![index];
            return InkWell(
              onTap: () {
                goToToy(
                  currentToy.id ?? -1,
                  currentToy.name ?? '',
                );
              },
              child: Stack(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.width / 2,
                      child: state.products![index].background != null
                          ? CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            imageUrl: state.products![index].gridImage!,
                            fit: BoxFit.fitWidth,
                          )
                          : Image.asset(
                              'assets/background.png',
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: CachedNetworkImage(
                        imageUrl: state.products![index].image!,
                      ),
                    ),
                  ),
                  if (state.products![index].brandImage != null)
                    Positioned(
                      bottom: 9,
                      left: 9,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.10,
                        child: CachedNetworkImage(
                          imageUrl: state.products![index].brandImage!,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  void scrollListener() {
    //load more data
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !isLoading) {
      isLoading = true;
      context.read<MainCubit>().getNewProducts().then((value) {
        isLoading = false;
      });
    }
  }

  void goToToy(int id, String name) async {
    context.read<ToyDetailsCubit>().getToyById(id);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: Toy3D(title: name),
      ),
    );
    getIt<SoundpoolManager>().play(soundName: 'Button-open');
  }

}
