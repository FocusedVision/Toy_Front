import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CubeLoader extends StatelessWidget {
  const CubeLoader({super.key, required this.loadingOffset});

  final double loadingOffset;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/cube_loader.json',
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: (MediaQuery.of(context).size.width / 3),
          height: MediaQuery.of(context).size.height * 0.01,
          decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.white,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Container(
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 3 -
                    ((MediaQuery.of(context).size.width / 3) * loadingOffset)),
            height: MediaQuery.of(context).size.height * 0.01,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )
      ],
    );
  }
}
