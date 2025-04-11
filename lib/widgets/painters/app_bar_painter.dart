import 'package:flutter/material.dart';

class AppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.103181, size.height * -0.4042577);
    path_0.cubicTo(
        size.width * 1.222037,
        size.height * -0.2640298,
        size.width * 1.344667,
        size.height * -0.06802981,
        size.width * 1.309077,
        size.height * 0.1343500);
    path_0.cubicTo(
        size.width * 1.273584,
        size.height * 0.3361933,
        size.width * 1.095395,
        size.height * 0.4306183,
        size.width * 0.9445707,
        size.height * 0.4976827);
    path_0.cubicTo(
        size.width * 0.8283893,
        size.height * 0.5493462,
        size.width * 0.7136133,
        size.height * 0.4667409,
        size.width * 0.5909280,
        size.height * 0.4536813);
    path_0.cubicTo(
        size.width * 0.4288640,
        size.height * 0.4364298,
        size.width * 0.1988075,
        size.height * 0.5973317,
        size.width * 0.1228941,
        size.height * 0.4102163);
    path_0.cubicTo(
        size.width * 0.04479840,
        size.height * 0.2177221,
        size.width * 0.3212827,
        size.height * 0.07287644,
        size.width * 0.3497653,
        size.height * -0.1407442);

    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffFFDA27);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.2714053, size.height * -0.5419183);
    path_1.cubicTo(
        size.width * 0.3606747,
        size.height * -0.6190433,
        size.width * 0.4300240,
        size.height * -0.9549471,
        size.width * 0.5125013,
        size.height * -0.9771971);
    path_1.cubicTo(
        size.width * 0.5853787,
        size.height * -0.9968558,
        size.width * 0.5407200,
        size.height * -0.7383413,
        size.width * 0.5582080,
        size.height * -0.6192885);
    path_1.cubicTo(
        size.width * 0.5731813,
        size.height * -0.5173510,
        size.width * 0.6303893,
        size.height * -0.4643774,
        size.width * 0.6078800,
        size.height * -0.3278947);
    path_1.cubicTo(
        size.width * 0.5852853,
        size.height * -0.1909058,
        size.width * 0.5028747,
        size.height * -0.07849423,
        size.width * 0.4479760,
        size.height * 0.04908510);
    path_1.cubicTo(
        size.width * 0.4016480,
        size.height * 0.1567394,
        size.width * 0.3652053,
        size.height * 0.2769548,
        size.width * 0.3103760,
        size.height * 0.3634519);
    path_1.cubicTo(
        size.width * 0.2519061,
        size.height * 0.4556952,
        size.width * 0.1891584,
        size.height * 0.5202933,
        size.width * 0.1303496,
        size.height * 0.5501683);
    path_1.cubicTo(
        size.width * 0.06786027,
        size.height * 0.5819135,
        size.width * 0.004438773,
        size.height * 0.5955144,
        size.width * -0.03209787,
        size.height * 0.5374375);
    path_1.cubicTo(
        size.width * -0.06830907,
        size.height * 0.4798793,
        size.width * -0.07559440,
        size.height * 0.3636563,
        size.width * -0.06485680,
        size.height * 0.2398798);

    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xffFA4616);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
