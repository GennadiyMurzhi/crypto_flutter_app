import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrencyChart extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List<double> dataCurrencyExemple = List(30);
    for(int i = 0; i < dataCurrencyExemple.length; i++){
      dataCurrencyExemple[i] = Random().nextInt(70).toDouble();
    }
    print(dataCurrencyExemple);
    // TODO: implement build
    return Stack(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.purpleAccent[700],
                Colors.purple[50]
              ]
            )
          ),
        ),
        Positioned(
          child: ClipPath(
            child: Container(color: Colors.white),
            clipper: GeneralClipper(true, dataCurrencyExemple),
          ),
        ),
        Positioned(
          child: ClipPath(
            child: Container(height: 100, color: Colors.black,),
            clipper: GeneralClipper(false, dataCurrencyExemple),
          ),
        ),
      ],
    );
  }

}

class GeneralClipper extends CustomClipper<Path>{
  final bool isFirstPart;
  final List<double> dataCurrency;
  double _correction = 3;

  double _stepChart;
  Offset _startFirstArc;
  Offset _endFirstArc;
  Offset _startSecondArc;
  Offset _endSecondArc;
  double _oddsPoints;
  bool _clockwiseArc;
  Radius _radiusFirst;
  Radius _radiusSecond;


  GeneralClipper(this.isFirstPart, this.dataCurrency){
    _correction = isFirstPart ? -_correction : _correction;
    print(_correction);
  }

  void _addPartCurrencyPath(Path path, double stepChart, double positionCurrency,
      double lastPositionCurrency, {double futurePositionCurrency}){
    _oddsPoints  = positionCurrency - lastPositionCurrency;
    if(_oddsPoints>0) _clockwiseArc = true; else _clockwiseArc = false;
    _startFirstArc = Offset(stepChart - this._stepChart, lastPositionCurrency);
    _endFirstArc = Offset(stepChart - this._stepChart/2, lastPositionCurrency + _oddsPoints/6);
    _startSecondArc = Offset(stepChart - this._stepChart/2, positionCurrency - _oddsPoints/6);
    _endSecondArc = Offset(stepChart, positionCurrency);
    _radiusFirst = Radius.circular(_oddsPoints/8);
    _radiusSecond = Radius.circular(_oddsPoints/2);

    if(futurePositionCurrency == null) path.arcToPoint(_endFirstArc,
        radius: Radius.circular(_oddsPoints/4), clockwise: _clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(_endFirstArc, radius: _radiusFirst, clockwise: _clockwiseArc);
    else path.arcToPoint(_endFirstArc, radius: _radiusSecond, clockwise: _clockwiseArc);
    path.lineTo(_startSecondArc.dx, _startSecondArc.dy);
    if(futurePositionCurrency == null) path.arcToPoint(_endSecondArc,
        radius: Radius.circular(_oddsPoints/4), clockwise: !_clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(_endSecondArc, radius: _radiusFirst, clockwise: !_clockwiseArc);
    else path.arcToPoint(_endSecondArc, radius: _radiusSecond, clockwise: !_clockwiseArc);
  }

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    this._stepChart = size.width / (dataCurrency.length-1);

    var path = Path();

    isFirstPart ? path.moveTo(0, 0) : path.moveTo(0, size.height);
    path.lineTo(0, dataCurrency[0] + _correction);

    for (int i = 1; i < dataCurrency.length; i++) {
      if (dataCurrency[i] == dataCurrency[i - 1])
        path.lineTo(i * _stepChart, dataCurrency[i] + _correction);
      else if (i == dataCurrency.length - 1)
        _addPartCurrencyPath(path, i * _stepChart,
            dataCurrency[i] + _correction, dataCurrency[i - 1] + _correction);
      else
        _addPartCurrencyPath(path, i * _stepChart,
            dataCurrency[i] + _correction, dataCurrency[i - 1] + _correction,
            futurePositionCurrency: dataCurrency[i + 1] + _correction);
    }

    if(isFirstPart == true){
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    } else {
      path.lineTo(size.width, size.height);
      path.moveTo(0, size.height);
    }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
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
    path.lineTo(startSecondArc.dx, startSecondArc.dy);
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