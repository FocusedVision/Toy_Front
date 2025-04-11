import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/config/style.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';
import 'package:virtual_toy_shop/data/const/const.dart';
import 'package:virtual_toy_shop/widgets/buttons/main_button.dart';

class NoConnection extends StatelessWidget {
  NoConnection({Key? key, this.isRetryAvailable = false}) : super(key: key);

  final bool isRetryAvailable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Image.asset(
                  'assets/icons/no-wifi.png',
                  height: MediaQuery.of(context).size.height * 0.095,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                noConnection,
                style: h2TextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.024),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'We noticed that you are not connected to the Internet. Connect it to be able to use the app. ',
                style: h4TextStyle.copyWith(
                    fontSize: MediaQuery.of(context).size.height * 0.019),
                textAlign: TextAlign.center,
              ),
              isRetryAvailable
                  ? Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: MainButton(
                        onTap: () {
                          context.read<MainCubit>().initialize();
                        },
                        mainColor: MyColors.grayLight,
                        shadowColor: MyColors.grayShadow,
                        label: 'Retry',
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
