import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_state.dart';
import 'package:virtual_toy_shop/presentation/profile/edit_profile_screen.dart';
import 'package:virtual_toy_shop/presentation/profile/privacy_policy_screen.dart';
import 'package:virtual_toy_shop/presentation/profile/terms_of_usage_screen.dart';
import 'package:virtual_toy_shop/widgets/app_bars/main_app_bar.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';
import 'package:virtual_toy_shop/widgets/containers/custom_avatar.dart';
import 'package:virtual_toy_shop/widgets/templates/no_connection.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return !state.noConnection
          ? Scaffold(
              extendBodyBehindAppBar: true,
              appBar: MainAppBar(
                label: 'Account',
                titleIcon: 'profile',
                action: IconButton(
                  onPressed: () {
                    context.read<ProfileCubit>().cleanPreviousData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(),
                      ),
                    );
                  },
                  icon: Image.asset(
                    'assets/icons/pencil.png',
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height * 0.13,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: kToolbarHeight + 80,
                      ),
                      CustomAvatar(
                        isSelected: true,
                        size: MediaQuery.of(context).size.height * 0.28,
                        image: state.user?.image ?? state.avatars?[0].url,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        state.user?.name ?? '',
                        style: h1TextStyle.copyWith(
                          fontSize: MediaQuery.of(context).size.height *
                              (0.13 * 34 / 110),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ProfileInfoPanel(),
                      Spacer(),
                      const PrivacyTemsButtons(),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              body: NoConnection(),
            );
    });
  }
}

class ProfileInfoPanel extends StatelessWidget {
  const ProfileInfoPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      return Row(
        children: [
          Expanded(
            child: ProfileInfoTile(
              label: 'Toys liked:',
              count: state.user?.likesCount ?? 0,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: ProfileInfoTile(
            label: 'In wishlist:',
            count: state.user?.productsCount ?? 0,
          )),
        ],
      );
    });
  }
}

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({
    Key? key,
    required this.label,
    required this.count,
  }) : super(key: key);

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.019, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: h2TextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height * 0.0236,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            count.toString(),
            style: h1TextStyle.copyWith(
              fontSize: MediaQuery.of(context).size.height * 0.057,
              color: MyColors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyTemsButtons extends StatelessWidget {
  const PrivacyTemsButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MainButton(
              shadowColor: MyColors.grayShadow,
              mainColor: MyColors.grayLight,
              label: 'Terms & Conditions',
              textSize: 16,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: TermsOfUsageScreen(),
                  ),
                );
              }),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: MainButton(
              shadowColor: MyColors.grayShadow,
              mainColor: MyColors.grayLight,
              label: 'Privacy',
              textSize: 16,
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: PrivacyPolicyScreen(),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
