import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CurrencyChart extends StatelessWidget{
  // TODO: implement build
  double _centerHeightChart;

  @override
  Widget build(BuildContext context) {
    List<double> dataCurrencyExemple = List(20);
    for(int i = 0; i < dataCurrencyExemple.length; i++){
      dataCurrencyExemple[i] = Random().nextInt(70).toDouble();
    }
    print(dataCurrencyExemple);
    _centerHeightChart =
        (dataCurrencyExemple.reduce(max) + dataCurrencyExemple.reduce(min)) / 2;

    return Stack(
      children: [
        CustomPaint(
          painter: CurrencyChartPainter(_centerHeightChart, dataCurrencyExemple),
          child: Container(),
        ),
        ClipPath(
          clipper: GradientClipper(dataCurrencyExemple.reduce(max), dataCurrencyExemple),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(33, 30, 255, 0.3),
                  Color.fromRGBO(255, 255, 255, 0)
                ]
              )
            ),
          ),
        )
      ]
    );
  }

}

class MakeCurrencyPath {
  final List<double> _dataCurrency;
  final double _widthContainer;

  var _path = Path();

  double _stepChart;
  Offset _startFirstArc;
  Offset _endFirstArc;
  Offset _startSecondArc;
  Offset _endSecondArc;
  double _oddsPoints;
  bool _clockwiseArc;

  MakeCurrencyPath(this._dataCurrency, this._widthContainer) {

    _stepChart = _widthContainer/(_dataCurrency.length-1);
    _path.moveTo(0, _dataCurrency[0]);

    for (int i = 1; i < _dataCurrency.length; i++) {
      if (_dataCurrency[i] == _dataCurrency[i - 1])
        _path.lineTo(i * _stepChart, _dataCurrency[i]);
      else if (i == _dataCurrency.length - 1)
        _addPartCurrencyPath(
            _path, i * _stepChart, _dataCurrency[i], _dataCurrency[i - 1]);
      else
        _addPartCurrencyPath(
            _path, i * _stepChart, _dataCurrency[i], _dataCurrency[i - 1],
            futurePositionCurrency: _dataCurrency[i + 1]);
    }
  }

  Path get currencyPath => _path;

  void _addPartCurrencyPath(Path path, double stepChart, double positionCurrency,
      double lastPositionCurrency, {double futurePositionCurrency}){
    _oddsPoints  = positionCurrency - lastPositionCurrency;
    if(_oddsPoints>0) _clockwiseArc = true; else _clockwiseArc = false;
    _startFirstArc = Offset(stepChart - this._stepChart, lastPositionCurrency);
    _endFirstArc = Offset(stepChart - this._stepChart/2, lastPositionCurrency + _oddsPoints/6);
    _startSecondArc = Offset(stepChart - this._stepChart/2, positionCurrency - _oddsPoints/6);
    _endSecondArc = Offset(stepChart, positionCurrency);

    if(futurePositionCurrency == null) path.arcToPoint(_endFirstArc,
        radius: Radius.circular(_oddsPoints/4), clockwise: _clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(_endFirstArc, radius: Radius.circular(_oddsPoints/4), clockwise: _clockwiseArc);
    else path.arcToPoint(_endFirstArc, radius: Radius.circular(_oddsPoints/4), clockwise: _clockwiseArc);
    path.lineTo(_startSecondArc.dx, _startSecondArc.dy);
    if(futurePositionCurrency == null) path.arcToPoint(_endSecondArc,
        radius: Radius.circular(_oddsPoints/2), clockwise: !_clockwiseArc);
    else if(positionCurrency > futurePositionCurrency)
      path.arcToPoint(_endSecondArc, radius: Radius.circular(_oddsPoints/4), clockwise: !_clockwiseArc);
    else path.arcToPoint(_endSecondArc, radius: Radius.circular(_oddsPoints/4), clockwise: !_clockwiseArc);
  }

}

class CurrencyChartPainter extends CustomPainter{
  final double centerHeightChart;
  final List dataCurrency;
  Path _currencyPath;

  CurrencyChartPainter(this.centerHeightChart, this.dataCurrency);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..shader = ui.Gradient.linear(
          Offset(size.width/2,0),
          Offset(size.width/2, size.height),
            [
              Color.fromRGBO(255, 25, 233, 1),
              Color.fromRGBO(33, 30, 255, 1)
            ]
        );

    _currencyPath = MakeCurrencyPath(dataCurrency, size.width).currencyPath;
    canvas.drawPath(_currencyPath, paint);
    canvas.save();
    canvas.restore();

    _currencyPath.reset();

    paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double partLineLength = size.width/100;
    double lineLength = 0;

    while(lineLength <= size.width){
      _currencyPath.moveTo(lineLength, centerHeightChart);
      _currencyPath.lineTo(lineLength + partLineLength, centerHeightChart);
      lineLength += (partLineLength + size.width/800) * 4;
    }

    canvas.drawPath(_currencyPath, paint);
    canvas.save();
    canvas.restore();

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}


class GradientClipper extends CustomClipper<Path>{
  final List dataCurrency;
  final double maxData;
  Path _currencyPath;

  GradientClipper(this.maxData, this.dataCurrency);

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    _currencyPath = MakeCurrencyPath(dataCurrency, size.width).currencyPath;
    _currencyPath.lineTo(size.width, maxData);
    _currencyPath.lineTo(0, maxData);
    _currencyPath.close();

    return _currencyPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}