import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrencyChart extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    List<double> dataCurrencyExemple = List(30);
    for(int i = 0; i < dataCurrencyExemple.length; i++){
      dataCurrencyExemple[i] = Random().nextInt(70).toDouble();
      print(dataCurrencyExemple[i]);
    };
    // TODO: implement build
    return CustomPaint(
      painter: CurrencyChartPainter(dataCurrencyExemple),
      child: Container(),
    );
  }

}

class CurrencyChartPainter extends CustomPainter{
  final List<double> dataCurrency;


  double stepChart = null;
  Offset startFirstArc;
  Offset endFirstArc;
  Offset startSecondArc;
  Offset endSecondArc;
  double oddsPoints;
  bool clockwiseArc;

  CurrencyChartPainter(this.dataCurrency);

  void _addPartCurrencyPath(Path path, double stepChart, double positionCurrency,
      double lastPositionCurrency, {double futurePositionCurrency}){
    oddsPoints  = positionCurrency - lastPositionCurrency;
    if(oddsPoints>0) clockwiseArc = true; else clockwiseArc = false;
    startFirstArc = Offset(stepChart - this.stepChart, lastPositionCurrency);
    endFirstArc = Offset(stepChart - this.stepChart/2, lastPositionCurrency + oddsPoints/6);
    startSecondArc = Offset(stepChart - this.stepChart/2, positionCurrency - oddsPoints/6);
    endSecondArc = Offset(stepChart, positionCurrency);
    
    if(futurePositionCurrency == null) path.arcToPoint(endFirstArc,
        radius: Radius.circular(oddsPoints/4), clockwise: clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(endFirstArc, radius: Radius.circular(oddsPoints/8), clockwise: clockwiseArc);
    else path.arcToPoint(endFirstArc, radius: Radius.circular(oddsPoints/2), clockwise: clockwiseArc);
    path.lineTo(startSecondArc.dx, startSecondArc.dy)
    if(futurePositionCurrency == null) path.arcToPoint(endSecondArc,
        radius: Radius.circular(oddsPoints/4), clockwise: !clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(endSecondArc, radius: Radius.circular(oddsPoints/8), clockwise: !clockwiseArc);
    else path.arcToPoint(endSecondArc, radius: Radius.circular(oddsPoints/2), clockwise: !clockwiseArc);
  }

  @override
  void paint(Canvas canvas, Size size) {
    this.stepChart = size.width / (dataCurrency.length-1);
    // TODO: implement paint
    var paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

    var path = Path()
       ..moveTo(0, dataCurrency[0]);

    for(int i = 1; i < dataCurrency.length; i++){
      if(dataCurrency[i] == dataCurrency[i-1]) path.lineTo(i*stepChart,
          dataCurrency[i]);
      else if(i == dataCurrency.length-1) _addPartCurrencyPath(path, i*stepChart,
          dataCurrency[i], dataCurrency[i-1]);
      else _addPartCurrencyPath(path, i*stepChart, dataCurrency[i],
            dataCurrency[i-1],  futurePositionCurrency: dataCurrency[i+1]);
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