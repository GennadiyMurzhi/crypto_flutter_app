import 'dart:ffi';
import 'dart:ui';

import 'package:crypto_flutter_app/SizingTool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoPaint extends StatelessWidget{

  Color colorCircle = Color.fromRGBO(21, 86, 214, 1.0);
  Color colorPathOfInnerCircle = Color.fromRGBO(0, 209, 234, 1.0);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      child: Stack(
        children: [
          CustomPaint(
            painter: InnerCircle(colorCircle),
            child: Container(),
          ),
          CustomPaint(
            painter: PathOfInnerCircle(colorPathOfInnerCircle),
            child: Container(),
          ),
          CustomPaint(
            painter: OuterCircle(colorCircle),
            child: Container(),
          ),
        ],
      ),
    );
  }
}


class InnerCircle extends CustomPainter{

  InnerCircle(this.colorCircle) : super();

  final Color colorCircle;

  @override
  void paint(Canvas canvas, Size size) {

    var paint = Paint()
      ..color = colorCircle
      ..strokeWidth = size.width/9.84
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var clipPath = Path()
      ..moveTo(size.width / 2, size.height / 2)
      ..lineTo(size.width / 2 + size.width / 4.1, size.height / 2 - size.width / 4.1)
      ..lineTo(size.width / 2, size.height / 2 - size.width / 2.73)
      ..lineTo(size.width / 2 - size.width / 3.78, size.height / 2 - size.width / 4.1)
      ..lineTo(size.width / 2 - size.width / 2.73, size.height / 2)
      ..lineTo(size.width / 2 - size.width / 3.78, size.height / 2 + size.width / 4.1)
      ..lineTo(size.width / 2 , size.height / 2 + size.width / 2.58)
      ..lineTo(size.width / 2 + size.width / 4.1, size.height / 2 + size.width / 4.1)
      ..lineTo(size.width / 2, size.height / 2)

      ..close();

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.clipPath(clipPath);
    canvas.drawCircle(center, size.width / 3.58 , paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class PathOfInnerCircle extends CustomPainter{

  PathOfInnerCircle(this.colorPathOfCircle) : super();

  final Color colorPathOfCircle;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
      ..color = colorPathOfCircle
      ..strokeWidth = size.width/9.84
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var clipPath = Path()
      ..moveTo(size.width / 2 + size.width / 12.3, size.height / 2)
      ..lineTo(size.width / 2 + size.width / 3.37, size.height / 2 - size.width / 5.4)
      ..lineTo(size.width / 2 + size.width / 2.45, size.height / 2)
      ..lineTo(size.width / 2 + size.width / 3.07, size.height / 2 + size.width / 5.13)
      ..lineTo(size.width / 2 + size.width / 12.3, size.height / 2)
      ..close();

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.clipPath(clipPath);
    canvas.drawCircle(center, size.width / 3.58, paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class OuterCircle extends CustomPainter{

  OuterCircle(this.colorCircle) : super();

  final Color colorCircle;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
      ..color = colorCircle
      ..strokeWidth = size.width / 9.84
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2.2, paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}


class BackgroundLogoPaint extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      //width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      CustomPaint(
        painter: BotommArcPainter(),
        child: Container(),
      );
  }

}

class BotommArcPainter extends CustomPainter{

  Color colorBackgroundLogo = Color.fromRGBO(239, 239, 239, 1);
  var sizing = Sizing().getInstence();

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Sizing.setSize(size);

    var paint = Paint()
        ..color = colorBackgroundLogo
        ..strokeWidth = 1
        ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, sizing.getValue(239))
      ..arcToPoint(Offset(size.width, sizing.getValue(239)), radius: Radius.circular(sizing.getStraight(198.49)),  clockwise: false)
      ..lineTo(size.width, sizing.getValue(180))
      ..arcToPoint(Offset(0, sizing.getValue(180)), radius: Radius.circular(sizing.getStraight(143)), clockwise: true)
      ..moveTo(sizing.getValue(192.97), sizing.getValue(171))
      ..arcToPoint(Offset( 0, sizing.getValue(127)), radius: Radius.circular(sizing.getStraight(118)), clockwise: true)
      ..lineTo(0, sizing.getValue(43))
      ..arcToPoint(Offset(sizing.getValue(28.97), 0), radius: Radius.circular(sizing.getStraight(118)), clockwise: true)
      ..lineTo(sizing.getValue(192.97), 0)
      ..lineTo(sizing.getValue(164.97), sizing.getValue(30))
      ..arcToPoint(Offset(sizing.getValue(36.97), sizing.getValue(85)), radius: Radius.circular(sizing.getStraight(76)), clockwise: false)
      ..arcToPoint(Offset(sizing.getValue(162.97), sizing.getValue(141)), radius: Radius.circular(sizing.getStraight(76)), clockwise: false)
      ..lineTo(sizing.getValue(192.97), sizing.getValue(171))
      ..moveTo(sizing.getValue(211.97), sizing.getValue(146))
      ..lineTo(sizing.getValue(181.97), sizing.getValue(117))
      ..arcToPoint(Offset(sizing.getValue(181.97), sizing.getValue(55)), radius: Radius.circular(sizing.getStraight(76)), clockwise: false)
      ..lineTo(sizing.getValue(213.97), sizing.getValue(22))
      ..arcToPoint(Offset(sizing.getValue(223.97), sizing.getValue(45)), radius: Radius.circular(sizing.getStraight(118)))
      ..lineTo(size.width, sizing.getValue(122))
      ..arcToPoint(Offset(sizing.getValue(211.97), sizing.getValue(146)), radius: Radius.circular(sizing.getStraight(118)));

    canvas.drawPath(path, paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}