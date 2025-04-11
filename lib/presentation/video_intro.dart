import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:virtual_toy_shop/cubit/main/main_cubit.dart';

class VideoIntro extends StatefulWidget {
  const VideoIntro({Key? key}) : super(key: key);

  @override
  State<VideoIntro> createState() => _VideoIntroState();
}

class _VideoIntroState extends State<VideoIntro> {
  late VideoPlayerController controller;
  Future? future;
  @override
  void initState() {
    controller = VideoPlayerController.asset("assets/intro_video.mp4");
    future = controller.initialize().then((value) {
      controller.play();

      controller.addListener(() {
        if (controller.value.position >=
            controller.value.duration - Duration(milliseconds: 1100)) {
          controller.dispose();
          //controller.pause();
          context.read<MainCubit>().checkIfUserExistsAndGoToMain();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(controller.value.aspectRatio);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 0), //MediaQuery.of(context).padding.top),
        child: Center(
          child: Transform.scale(
            scale: 1.02,
            child: AspectRatio(
              aspectRatio: 0.5625,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ),
    );
  }
}
