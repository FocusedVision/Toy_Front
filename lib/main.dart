import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_toy_shop/config/my_colors.dart';
import 'package:virtual_toy_shop/cubit/profile/profile_cubit.dart';
import 'package:virtual_toy_shop/cubit/toy_details/toy_details_cubit.dart';
import 'package:virtual_toy_shop/presentation/start_navigation.dart';

import 'config/get_it.dart';
import 'config/notification.dart';
import 'cubit/main/main_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit()..initialize(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit()..initialize(),
        ),
        BlocProvider(
          create: (context) => ToyDetailsCubit(),
        ),
      ],
      child: MaterialApp(
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaleFactor: (MediaQuery.of(context).size.height < 720 ||
                        MediaQuery.of(context).size.width < 340)
                    ? 0.8
                    : 1),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'VAG Rounded Std',
          scaffoldBackgroundColor: MyColors.background,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
        home: const StartNavigation(),
      ),
    );
  }
}
