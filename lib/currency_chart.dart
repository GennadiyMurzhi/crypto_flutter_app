import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CurrencyChart extends StatelessWidget{
  // TODO: implement build
  final List<double> dataCurrency;

  CurrencyChart(this.dataCurrency);

  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: CurrencyChartPainter(dataCurrency),
          child: Container(),
        ),
        GradientPart(dataCurrency)
      ]
    );
  }

}

class DetailCurrencyChart extends StatefulWidget{
  final List<double> dataCurrency;
  bool isRepaint;

  DetailCurrencyChart(this.dataCurrency, this.isRepaint);

  @override
  _DetailCurrencyChartState createState() =>
      _DetailCurrencyChartState();
}

class _DetailCurrencyChartState extends State<DetailCurrencyChart>{

  Offset _leftPoint;
  Offset _rightPoint;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(widget.isRepaint){
      _rightPoint = null;
      _leftPoint = null;
      widget.isRepaint = false;
    }

    return Stack(
        children: [
          CustomPaint(
            painter: CurrencyChartDetailPainter(widget.dataCurrency, _leftPoint,
            _rightPoint),
            child: Container()
          ),
          GradientPart(widget.dataCurrency),
          Container(
            child: GestureDetector(
              onTapDown: (tapPoint){
                if(_leftPoint == null)_leftPoint = tapPoint.localPosition; //1
                else if(_leftPoint != null && _rightPoint == null){ //2
                  if(tapPoint.localPosition.dx < _leftPoint.dx){
                    _rightPoint = _leftPoint;
                    _leftPoint = tapPoint.localPosition;
                  } else if(tapPoint.localPosition.dx > _leftPoint.dx)
                    _rightPoint = tapPoint.localPosition;
                  else _leftPoint = tapPoint.localPosition;
                } else if(_leftPoint != null && _rightPoint != null){ //3
                  double distancePoints = _rightPoint.dx - _leftPoint.dx;
                  if(tapPoint.localPosition.dx == _leftPoint.dx + distancePoints / 2) { // 3.1
                    if(Random().nextBool()) _leftPoint = tapPoint.localPosition;
                    else _rightPoint = tapPoint.localPosition;
                  } else if(_leftPoint.dx < tapPoint.localPosition.dx
                      && tapPoint.localPosition.dx < _leftPoint.dx + distancePoints / 2) // 3.2
                    _leftPoint = tapPoint.localPosition;
                  else if(_leftPoint.dx + distancePoints / 2 < tapPoint.localPosition.dx
                  && tapPoint.localPosition.dx < _rightPoint.dx) // 3.3
                    _rightPoint = tapPoint.localPosition;
                  else if(tapPoint.localPosition.dx <= _leftPoint.dx) // 3.4
                    _leftPoint = tapPoint.localPosition;
                  else if(tapPoint.localPosition.dx >= _rightPoint.dx) // 3.5
                    _rightPoint = tapPoint.localPosition;
                }
                setState(() {});
              },
            ),
          )
        ]
    );
  }
}

class GradientPart extends StatelessWidget{
  final List<double> dataCurrency;

  const GradientPart(this.dataCurrency);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipPath(
      clipper: GradientClipper(dataCurrency.reduce(max), dataCurrency),
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
    );
  }

}

class MakeCurrencyPath {

  var _path = Path();

  double _stepChart;
  Offset _startFirstArc;
  Offset _endFirstArc;
  Offset _startSecondArc;
  Offset _endSecondArc;
  double _oddsPoints;
  bool _clockwiseArc;

  Path makePath (List<double> dataCurrency, double widthContainer){
    double step = getStep(dataCurrency, widthContainer);
    Path path = Path();
    path.moveTo(0, dataCurrency[0]);

    for (int i = 1; i < dataCurrency.length; i++) {
      if (dataCurrency[i] == dataCurrency[i - 1])
        path.lineTo(i * step, dataCurrency[i]);
      else if (i == dataCurrency.length - 1)
        _addPartCurrencyPath(
            path, i * step, step, dataCurrency[i], dataCurrency[i - 1]);
      else
        _addPartCurrencyPath(
            path, i * step, step, dataCurrency[i], dataCurrency[i - 1],
            futurePositionCurrency: dataCurrency[i + 1]);
    }
    return path;
  }

  Path get currencyPath => _path;

  double getStep(List<double> dataCurrency, double widthContainer) =>
      widthContainer/(dataCurrency.length-1);

  void _addPartCurrencyPath(Path path, double stepChart, double step,
      double positionCurrency, double lastPositionCurrency,
      {double futurePositionCurrency}){
    _oddsPoints  = positionCurrency - lastPositionCurrency;
    if(_oddsPoints>0) _clockwiseArc = true; else _clockwiseArc = false;
    _startFirstArc = Offset(stepChart - step, lastPositionCurrency);
    _endFirstArc = Offset(stepChart - step/2, lastPositionCurrency + _oddsPoints/6);
    _startSecondArc = Offset(stepChart - step/2, positionCurrency - _oddsPoints/6);
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

class CurrencyChartPainter extends CustomPainter with MakeCurrencyPath{

  final List<double> dataCurrency;

  CurrencyChartPainter(this.dataCurrency);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    drawChart(canvas, size);

    drawSeparatedLine(canvas, size);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

  void drawChart(Canvas canvas, Size size){
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

    var path = makePath(dataCurrency, size.width);
    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
  }

  void drawSeparatedLine(Canvas canvas, Size size){
    var paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double partLineLength = size.width/100;
    double lineLength = 0;

    double centerHeightChart = (dataCurrency.reduce(max)
        + dataCurrency.reduce(min)) / 2;

    var path = Path();

    while(lineLength <= size.width){
      path.moveTo(lineLength, centerHeightChart);
      path.lineTo(lineLength + partLineLength, centerHeightChart);
      lineLength += (partLineLength + size.width/800) * 4;
    }

    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
  }

}

class GradientClipper extends CustomClipper<Path> with MakeCurrencyPath{
  final List dataCurrency;
  final double maxData;
  Path _currencyPath;

  GradientClipper(this.maxData, this.dataCurrency);

  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    _currencyPath = makePath(dataCurrency, size.width);
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

class CurrencyChartDetailPainter extends CurrencyChartPainter{
  Offset _leftPoint;
  Offset _rightPoint;

  CurrencyChartDetailPainter(List<double> dataCurrency, this._leftPoint,
      this._rightPoint) : super(dataCurrency);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    // TODO: implement paint
    Offset leftCurrencyPoint;
    Offset rightCurrencyPoint;
    int indexLeftPoint;
    int indexRightPoint;

    if(_leftPoint != null) {
      indexLeftPoint = getIndexCurrencyPoint(_leftPoint.dx, size.width);
      leftCurrencyPoint = getSCurrencyPoint(indexLeftPoint, size.width);
      drawBackgroundCircle(canvas, leftCurrencyPoint, 3);
    }
    if(_rightPoint != null) {
      indexRightPoint = getIndexCurrencyPoint(_rightPoint.dx, size.width);
      rightCurrencyPoint = getSCurrencyPoint(indexRightPoint, size.width);
      drawBackgroundCircle(canvas, rightCurrencyPoint, 3);
    }

    if(_leftPoint != null && _rightPoint != null){ //рисуем кривые
      List<int> vertices = getVertices(indexLeftPoint, indexRightPoint);
      print(vertices);
      if(vertices.length == 4){
        drawContactBlueCurve(canvas, indexLeftPoint, indexRightPoint, vertices[0],
            vertices[3], size);
        /*drawContactOrangeCurve(canvas, indexLeftPoint, indexRightPoint,
            vertices[0], vertices[2], vertices[3], size.width);
        drawContactLightBlueCurve(canvas, indexLeftPoint, indexRightPoint,
            vertices[1], vertices[2], size.width);*/
      }
    }

    //drawChart(canvas, size);

    if(_leftPoint != null) drawForegroundCircle(canvas, leftCurrencyPoint, 2.5);
    if(_rightPoint != null) drawForegroundCircle(canvas, rightCurrencyPoint, 2.5);

    drawSeparatedLine(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

  void drawBackgroundCircle(Canvas canvas, Offset currencyPoint,
      double strokeWidth){
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.grey.withOpacity(0.5);

    canvas.drawCircle(currencyPoint, strokeWidth * 3, paint);
  }

  void drawForegroundCircle(Canvas canvas, Offset currencyPoint,
      double strokeWidth){
    var paintInner = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    var paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = Colors.blue[700];

    canvas.drawCircle(currencyPoint, strokeWidth * 2, paintInner);

    canvas.drawCircle(currencyPoint, strokeWidth * 2, paintStroke);
  }

  void drawContactBlueCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexFirstVertex, int indexFourthVertex, Size sizeContainer){
    var paint = Paint()
        ..color = Color.fromRGBO(55, 107, 207, 1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

    double step = getStep(dataCurrency, sizeContainer.width);
    double percentWidth = sizeContainer.width / 100;
    double percentHeight = sizeContainer.height / 100;


    //(absciss or ordinat control point design *100 / widthSpline design) / 100


    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint]);
    double splineWidth = (indexFirstVertex - indexLeftPoint) * step;
    double splineHeight;
    //spline 1
    if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex])
      splineHeight = dataCurrency[indexLeftPoint];
    else splineHeight = dataCurrency[indexFirstVertex];
    if(dataCurrency[indexLeftPoint] < dataCurrency[indexFirstVertex]){
      path.cubicTo(
          indexLeftPoint * step + splineWidth * 15.6 / sizeContainer.width,
          dataCurrency[indexLeftPoint] + splineHeight * 14.3 / sizeContainer.height, //control one
          indexLeftPoint * step + splineWidth * 40.5 / sizeContainer.width,
          dataCurrency[indexLeftPoint] + splineHeight * 23.1 / sizeContainer.height, // control two
          indexFirstVertex * step, dataCurrency[indexFirstVertex]
      );
    } else {
      path.cubicTo(
          indexLeftPoint * step + splineWidth * 15.6 / sizeContainer.width,
          dataCurrency[indexLeftPoint] - splineHeight * 14.3 / sizeContainer.height, //control one
          indexLeftPoint * step + splineWidth * 40.5 / sizeContainer.width,
          dataCurrency[indexLeftPoint] - splineHeight * 23.1 / sizeContainer.height, // control two
          indexFirstVertex * step, dataCurrency[indexFirstVertex]
      );
    }
    //spline 2
    splineWidth = (indexFourthVertex - indexFirstVertex) * step;
    if(dataCurrency[indexFirstVertex] > dataCurrency[indexFourthVertex])
      splineHeight = dataCurrency[indexFirstVertex];
    else splineHeight = dataCurrency[indexFourthVertex];
    if(dataCurrency[indexFirstVertex] < dataCurrency[indexFourthVertex]){
      path.cubicTo(
          indexFirstVertex * step + splineWidth * 56.5 / sizeContainer.width,
          dataCurrency[indexFirstVertex] + splineHeight * -2.2 / sizeContainer.height, //control one
          indexFirstVertex * step + splineWidth * 53.8 / sizeContainer.width,
          dataCurrency[indexFirstVertex] + splineHeight * 59.5 / sizeContainer.height,// control two
          indexFourthVertex * step, dataCurrency[indexFourthVertex]
      );
    } else {
      path.cubicTo(
          indexFirstVertex * step + splineWidth * 56.5 / sizeContainer.width,
          dataCurrency[indexFirstVertex] - splineHeight * -2.2 / sizeContainer.height, //control one
          indexFirstVertex * step + splineWidth * 53.8 / sizeContainer.width,
          dataCurrency[indexFirstVertex] - splineHeight * 59.5 / sizeContainer.height,// control two
          indexFourthVertex * step, dataCurrency[indexFourthVertex]
      );
    }
    //spline 3
    splineWidth = (indexRightPoint - indexFourthVertex) * step;
    if(dataCurrency[indexFourthVertex] > dataCurrency[indexRightPoint])
      splineHeight = dataCurrency[indexFourthVertex];
    else splineHeight = dataCurrency[indexRightPoint];
    if(dataCurrency[indexFourthVertex] < dataCurrency[indexRightPoint]){
      path.cubicTo(
          indexFourthVertex * step + splineWidth * 23.3 / sizeContainer.width,
          dataCurrency[indexFourthVertex] + splineHeight * 0.9 / sizeContainer.height,//control one
          indexFourthVertex * step + splineWidth * 76.3 / sizeContainer.width,
          dataCurrency[indexFourthVertex] + splineHeight * 1.2 / sizeContainer.height,// control two
          indexRightPoint * step, dataCurrency[indexRightPoint]
      );
    } else {
      path.cubicTo(
          indexFourthVertex * step + splineWidth * 23.3 / sizeContainer.width,
          dataCurrency[indexFourthVertex] - splineHeight * 0.9 / sizeContainer.height,//control one
          indexFourthVertex * step + splineWidth * 76.3 / sizeContainer.width,
          dataCurrency[indexFourthVertex] - splineHeight * 1.2 / sizeContainer.height,// control two
          indexRightPoint * step, dataCurrency[indexRightPoint]
      );
    }
      /*..quadraticBezierTo(indexLeftPoint * step, dataCurrency[indexLeftPoint],
          indexFirstVertex * step, dataCurrency[indexFirstVertex])
      ..quadraticBezierTo(indexFirstVertex * step, dataCurrency[indexFirstVertex],
          indexFourthVertex * step, dataCurrency[indexFourthVertex])
      ..quadraticBezierTo(indexFourthVertex * step, dataCurrency[indexFourthVertex],
          indexRightPoint * step, dataCurrency[indexRightPoint]);*/

    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
  }

  void drawContactOrangeCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexFirstVertex, int indexThirdVertex, int indexFourthVertex, double widthContainer){
    var paint = Paint()
      ..color = Color.fromRGBO(241, 138, 157, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double step = getStep(dataCurrency, widthContainer);

    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint])
      ..quadraticBezierTo(indexLeftPoint * step, dataCurrency[indexLeftPoint],
          indexFirstVertex * step, dataCurrency[indexFirstVertex])
      ..quadraticBezierTo(indexFirstVertex * step,
          dataCurrency[indexFirstVertex],
          indexThirdVertex * step, dataCurrency[indexThirdVertex])
      ..quadraticBezierTo(indexThirdVertex * step,
          dataCurrency[indexThirdVertex],
          indexFourthVertex * step, dataCurrency[indexFourthVertex])
      ..quadraticBezierTo(indexFourthVertex * step,
          dataCurrency[indexFourthVertex],
          indexRightPoint * step, dataCurrency[indexRightPoint]);

    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
  }
  void drawContactLightBlueCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexSecondVertex, int indexThirdVertex, double widthContainer){
    var paint = Paint()
      ..color = Color.fromRGBO(48, 180, 211, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double step = getStep(dataCurrency, widthContainer);

    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint])
      ..quadraticBezierTo(indexLeftPoint * step, dataCurrency[indexLeftPoint], indexSecondVertex * step,
          dataCurrency[indexSecondVertex])
      ..quadraticBezierTo(indexSecondVertex * step,
          dataCurrency[indexSecondVertex], indexThirdVertex * step,
          dataCurrency[indexThirdVertex])
      ..quadraticBezierTo(indexThirdVertex * step,
          dataCurrency[indexThirdVertex], indexRightPoint * step,
          dataCurrency[indexRightPoint]);

    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
  }

  List<int> getVertices(int indexLeftPoint, int indexRightPoint) {
    List<int> vertices = [];
    List<double> copyData = List.from(dataCurrency);
    copyData.removeRange(indexRightPoint, copyData.length);
    while (vertices.length < 4) {
      int index = copyData.indexOf(copyData.reduce(min));
      if (index > indexLeftPoint) vertices.add(index);
      copyData.removeAt(index);
      copyData.insert(index, double.infinity);
      if (copyData[copyData.length - 1] == 0 && vertices.length == 4) break;
    }
    vertices.sort();

    return vertices;
  }

  Offset getSCurrencyPoint(int indexCurrencyPoint, double widthContainer) =>
      Offset(indexCurrencyPoint * getStep(dataCurrency, widthContainer),
          dataCurrency[indexCurrencyPoint]);
  int getIndexCurrencyPoint(double abscissa, double widthContainer){
    int index;
    double step = getStep(dataCurrency, widthContainer);
    for (int i = 0; i < dataCurrency.length - 1; i++) {
      if (i * step <= abscissa && (i + 1) * step >= abscissa) {
        double middleStepChart = i * step + step / 2;
        switch (middleStepChart.compareTo(abscissa)) {
          case -1:
            index = i + 1;
            break;
          case 1:
            index = i;
            break;
          case 0:
            if (Random().nextBool())
              index = i + 1;
            else
              index = i;
            break;
        }
      }
    }
    return index;
  }
}