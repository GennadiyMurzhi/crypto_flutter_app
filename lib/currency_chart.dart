import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrencyChart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    List<double> dataCurrencyExemple = List(3);
    for(int i = 0; i < dataCurrencyExemple.length; i++){
      dataCurrencyExemple[i] = Random().nextInt(70).toDouble();
      print(dataCurrencyExemple[i]);
    };
    List<double> dataCurrencyExemple2 = [30, 70];
    // TODO: implement build
    return CustomPaint(
      painter: CurrencyChartPainter(dataCurrencyExemple2),
      child: Container(),
    );
  }

}

class CurrencyChartPainter extends CustomPainter{
  final List<double> dataCurrency;


  final double stepChart = 8;
  Offset startFirstArc;
  Offset endFirstArc;
  Offset startSecondArc;
  Offset endSecondArc;
  double oddsPoints;

  CurrencyChartPainter(this.dataCurrency);

  void _addPartCurrencyPath(Path path, double stepChart, double positionCurrency,
      double lastPositionCurrency){
    oddsPoints  = positionCurrency - lastPositionCurrency;
    startFirstArc = Offset(stepChart - this.stepChart, lastPositionCurrency);
    endFirstArc = Offset(stepChart - this.stepChart/2, lastPositionCurrency + oddsPoints/4);
    startSecondArc = Offset(stepChart + this.stepChart/2, positionCurrency - oddsPoints/4);
    endSecondArc = Offset(stepChart + this.stepChart, positionCurrency);

    path.arcTo(Rect.fromPoints(startFirstArc, endFirstArc), 1.5 * pi, 0.5 * pi, false);
    path.lineTo(startSecondArc.dx, startSecondArc.dy);
    path.arcTo(Rect.fromPoints(endSecondArc, startSecondArc), 1 * pi, 0 * pi, false);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

    var path = Path()
       ..moveTo(0, dataCurrency[0]);

    for(int i = 1; i < dataCurrency.length; i++){
      _addPartCurrencyPath(path, i*stepChart, dataCurrency[i],
          dataCurrency[i-1]);
    }


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