import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/presentation/home_screen.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/presentation/profile/welcome_profile_screen.dart';
import 'package:virtual_toy_shop/presentation/video_intro.dart';
import 'package:virtual_toy_shop/widgets/templates/no_connection.dart';

class StartNavigation extends StatefulWidget {
  const StartNavigation({Key? key}) : super(key: key);

  @override
  _StartNavigationState createState() => _StartNavigationState();
}

class _StartNavigationState extends State<StartNavigation> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      if (state.screen == MainStateScreen.main) {
        return const HomeScreen();
      } else if (state.screen == MainStateScreen.intro) {
        return VideoIntro();
      } else if (state.screen == MainStateScreen.loading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: MyColors.orange,
            ),
          ),
        );
      } else if (state.screen == MainStateScreen.noConnection) {
        return Scaffold(
          body: NoConnection(
            isRetryAvailable: true,
          ),
        );
      } else if (state.screen == MainStateScreen.newUser) {
        return const WelcomeProfileScreen();
      } else {
        return const Scaffold();
      }
    });
    //return BlocBuilder();
  }
}
