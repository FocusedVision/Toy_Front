import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/presentation/all_toys/all_toys_screen.dart';
import 'package:virtual_toy_shop/presentation/profile/profile_screen.dart';
import 'package:virtual_toy_shop/presentation/wishlist/wishlist_screen.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      return Scaffold(
        //extendBody: true,
        bottomNavigationBar: navigationBar(state, context),
        body: tabs(context)[state.tabIndex],
      );
    });
  }

//old navigationBar
/*  Container navigationBar(MainState state) {
    return Container(
      height: 65,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, -4),
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
      ),
      child: Row(
        children: navBarItems(state),
      ),
    );
  }*/

  Container navigationBar(MainState state, BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.13,
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).size.height * 0.019, 16, 0),
      decoration: const BoxDecoration(
        color: MyColors.background,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, -2),
            color: Color.fromRGBO(51, 51, 51, 0.25),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          children: navBarItems(state),
        ),
      ),
    );
  }

  List<Widget> navBarItems(MainState state) {
    bool isSmallDisplay = MediaQuery.of(context).size.width < 400;
    return [
      Expanded(
        flex: 1,
        child: MainButton(
          onTap: () {
            context.read<MainCubit>().changeTab(0);
            context.read<ProfileCubit>().getUser();
            context.read<ProfileCubit>().getAvatars();
          },
          mainColor: MyColors.purpleLight,
          shadowColor: MyColors.purpleShadow,
          icon: 'profile',
        ),
      ),
      const SizedBox(
        width: 8,
      ),
      Expanded(
        flex: 2,
        child: MainButton(
          onTap: () {
            context.read<MainCubit>().changeTab(1);
          },
          mainColor: MyColors.greenLight,
          shadowColor: MyColors.greenShadow,
          icon: 'toys',
          label: 'Toys'.toUpperCase(),
          textSize: isSmallDisplay ? 16 : 18,
        ),
      ),
      const SizedBox(
        width: 8,
      ),
      Expanded(
        flex: 2,
        child: MainButton(
          onTap: () {
            context.read<MainCubit>().changeTab(2);
          },
          mainColor: MyColors.orangeLight,
          shadowColor: MyColors.orangeShadow,
          icon: 'heart',
          label: 'Wishlist'.toUpperCase(),
          textSize: isSmallDisplay ? 16 : 18,
        ),
      ),
    ];
  }

  List<Widget> tabs(BuildContext context) {
    return [
      const ProfileScreen(),
      const AllToysScreen(),
      const WishlistScreen(),
    ];
  }
}
