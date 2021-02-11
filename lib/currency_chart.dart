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
    // TODO: implement build
    return CustomPaint(
      painter: CurrencyChartPainter(dataCurrencyExemple),
      child: Container(),
    );
  }

}

class CurrencyChartPainter extends CustomPainter{
  final List<double> dataCurrency;


  final double stepChart = 8;
  double _halfWay;
  double _endHalfWay;
  bool _clockwise;

  CurrencyChartPainter(this.dataCurrency);

  void _addPartCurrencyPath(Path path, double stepChart, double positionCurrency,
      double lastPositionCurrency){
    //path.lineTo(stepChart, positionCurrency);
    _halfWay = (positionCurrency - lastPositionCurrency).abs();

    if(positionCurrency>lastPositionCurrency) _endHalfWay = lastPositionCurrency + _halfWay;
    else _endHalfWay = lastPositionCurrency - _halfWay;

    if(positionCurrency>lastPositionCurrency) _clockwise = false;
    else _clockwise = true;

    path.arcToPoint(Offset(stepChart, _endHalfWay), radius: Radius.circular(stepChart), clockwise: _clockwise);
    path.arcToPoint(Offset(stepChart, positionCurrency), radius: Radius.circular(stepChart), clockwise: !_clockwise);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;

    var path = Path()
       ..moveTo(0, dataCurrency[0]);

    for(int i = 1; i < dataCurrency.length; i++){

      
      _addPartCurrencyPath(path, i*stepChart  + stepChart, dataCurrency[i],
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