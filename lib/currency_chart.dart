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

    Offset controlOne = Offset(stepChart - step + step/1.5, lastPositionCurrency);
    Offset controlTwo = Offset(stepChart - step/1.5, positionCurrency);
    Offset endSegment = Offset(stepChart, positionCurrency);

    path.cubicTo(controlOne.dx, controlOne.dy, controlTwo.dx, controlTwo.dy,
        endSegment.dx, endSegment.dy);
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

    if(_leftPoint != null && _rightPoint != null){
      List<int> vertices = getVertices(indexLeftPoint, indexRightPoint);
      if(vertices.length == 4){
        //orangeCurve
        drawCurve(canvas, indexLeftPoint, indexRightPoint, vertices[0],
            vertices[2], size, Color.fromRGBO(244, 71, 109, 1.0));
        //blue curve
        drawCurve(canvas, indexLeftPoint, indexRightPoint, vertices[0],
            vertices[3], size, Color.fromRGBO(55, 107, 207, 1.0));

        //lightBlueCurve
        drawCurve(canvas, indexLeftPoint, indexRightPoint, vertices[1],
            vertices[2], size, Color.fromRGBO(48, 180, 211, 1));/**/

      }
    }

    drawChart(canvas, size);

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

  void drawCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexFirstVertex, int indexSecondVertex, Size sizeContainer, Color color){

    var paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

    double step = getStep(dataCurrency, sizeContainer.width);
    //(absciss or ordinat control point design *100 / widthSpline design) / 100

    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint]);
    double segmentWidth = (indexFirstVertex - indexLeftPoint) * step;
    double percentSegment1 = segmentWidth * 100 / sizeContainer.width; //percent of Segment1 of Container

          //**************************SEGMENT 1**************************//
    Offset controlOne;
    if ((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]).abs() >=
            30 &&
        indexFirstVertex - indexLeftPoint >= 11) //case5
      controlOne = Offset(indexLeftPoint * step + percentSegment1 * 0.4375 * 2,
          dataCurrency[indexLeftPoint] + percentSegment1 * 1.0842 / 2.5);
    else if (dataCurrency[indexLeftPoint] <= 15 &&
        dataCurrency[indexFirstVertex] <= 15 &&
        indexFirstVertex - indexLeftPoint >= 8) //case6
      controlOne = Offset(indexLeftPoint * step + percentSegment1 * 0.4375 * 3.5,
          dataCurrency[indexLeftPoint] - percentSegment1 * 1.0842 / 3.5);
    else
      controlOne = Offset(indexLeftPoint * step + percentSegment1 * 0.4375,
          dataCurrency[indexLeftPoint] + percentSegment1 * 1.0842);
    //                               NEXT                                  //
    //                              CONTROL                                //
    //                               POINT                                 //
    Offset controlTwo;
    if (dataCurrency[indexLeftPoint] <= 15 &&
        dataCurrency[indexFirstVertex] <= 15 &&
        indexFirstVertex - indexLeftPoint >= 8) //case6
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 0.7527,
          dataCurrency[indexLeftPoint] + percentSegment1 * 1.575);
    else if ((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]).abs() <=
            20 &&
        indexFirstVertex - indexLeftPoint >= 6 &&
        indexFirstVertex - indexLeftPoint <= 10) // case1
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 2.7527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 0.875);
    else if ((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex])
                .abs() >=
            20 &&
        (dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]).abs() <=
            60 &&
        indexFirstVertex - indexLeftPoint >= 5 &&
        indexFirstVertex - indexLeftPoint <= 9) //case2
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 1.9727,
          dataCurrency[indexLeftPoint] - percentSegment1 * 1.875);
    else if((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex])
        .abs() >=
        40 &&
        indexFirstVertex - indexLeftPoint >= 2 &&
        indexFirstVertex - indexLeftPoint <= 5) //case3
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 1.7527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 3.575);
    else if((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex])
        .abs() <=
        40 &&
        indexFirstVertex - indexLeftPoint <= 2) //case4
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 0.7527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 1.575);
    else if((dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex])
        .abs() >=
        30 &&
        indexFirstVertex - indexLeftPoint >= 11) //case5
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 2.2527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 0.575);
    else
      controlTwo = Offset(indexLeftPoint * step + percentSegment1 * 0.7527,
          dataCurrency[indexLeftPoint] + percentSegment1 * 0.875);

    Offset endPoint = Offset(indexFirstVertex * step,
        dataCurrency[indexFirstVertex]);

    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy, // control two
        endPoint.dx, endPoint.dy
    );

          //**************************SEGMENT 2**************************//
    segmentWidth = (indexSecondVertex - indexFirstVertex) * step;
    double percentSegment2 = segmentWidth * 100 / sizeContainer.width; //percent of Segment2 of Container
    Offset differenceValues = Offset(endPoint.dx - controlTwo.dx,
        endPoint.dy - controlTwo.dy);

    if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() <= 20 &&
        indexSecondVertex - indexFirstVertex <= 4) // case1
      controlOne = Offset(endPoint.dx + differenceValues.dx / 10,
          endPoint.dy + differenceValues.dy / 10);
    else if ((dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
        .abs() <=
        20 &&
        indexSecondVertex - indexFirstVertex >= 7 &&
        indexSecondVertex - indexFirstVertex <= 16) //case3
      controlOne = Offset(endPoint.dx + differenceValues.dx / 3.5,
          endPoint.dy + differenceValues.dy / 7);
    else if ((dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
        .abs() <=
        10 &&
        indexSecondVertex - indexFirstVertex >= 2 &&
        indexSecondVertex - indexFirstVertex <= 6) //case4
      controlOne = Offset(endPoint.dx + differenceValues.dx / 5,
          endPoint.dy + differenceValues.dy / 7);
    else if (dataCurrency[indexFirstVertex] <= 10 &&
        dataCurrency[indexSecondVertex] <= 10 &&
        indexSecondVertex - indexFirstVertex >= 10 &&
        indexSecondVertex - indexFirstVertex <= 14) //case5
      controlOne = Offset(endPoint.dx + differenceValues.dx / 2.5,
          endPoint.dy + differenceValues.dy / 2.5);
    else if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() >= 20 &&
        indexSecondVertex - indexFirstVertex <= 4) // case6
      controlOne = Offset(endPoint.dx + differenceValues.dx / 5,
          endPoint.dy + differenceValues.dy / 12);
    else if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() <= 20 &&
        indexSecondVertex - indexFirstVertex >= 5 &&
        indexSecondVertex - indexFirstVertex <= 12) //case7
      controlOne = Offset(endPoint.dx + differenceValues.dx * 1.7,
          endPoint.dy + differenceValues.dy / 2);
    else if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() <= 20 &&
        indexSecondVertex - indexFirstVertex >= 12) //case8
      controlOne = Offset(endPoint.dx + differenceValues.dx * 0.7,
          endPoint.dy + differenceValues.dy / 1.5);
    else controlOne = Offset(endPoint.dx + differenceValues.dx,
          endPoint.dy + differenceValues.dy);
    //                               NEXT                                  //
    //                              CONTROL                                //
    //                               POINT                                 //
    if ((dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
                .abs() >=
            21 &&
        (dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
            .abs() <=
            31 &&
        indexSecondVertex - indexFirstVertex >= 7 &&
        indexSecondVertex - indexFirstVertex <= 11) //case2
      controlTwo = Offset(endPoint.dx + percentSegment2 * 2.9595,
          endPoint.dy + percentSegment2 * 1.0080);
    else if (dataCurrency[indexFirstVertex] <= 10 &&
        dataCurrency[indexSecondVertex] <= 10 &&
        indexSecondVertex - indexFirstVertex >= 10 &&
        indexSecondVertex - indexFirstVertex <= 14) //case5
      controlTwo = Offset(endPoint.dx + percentSegment2 * 0.7595,
          endPoint.dy + percentSegment2 * 1.5080);
    else if ((dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
        .abs() <=
        20 &&
        indexSecondVertex - indexFirstVertex >= 7 &&
        indexSecondVertex - indexFirstVertex <= 16) //case3
      controlTwo = Offset(endPoint.dx + percentSegment2 * 0.1595,
          endPoint.dy + percentSegment2 * 2.5080);
    else if ((dataCurrency[indexFirstVertex] - dataCurrency[indexSecondVertex])
        .abs() <=
        10 &&
        indexSecondVertex - indexFirstVertex >= 2 &&
        indexSecondVertex - indexFirstVertex <= 6) //case4
      controlTwo = Offset(endPoint.dx + percentSegment2 * 0.1595,
          endPoint.dy + percentSegment2 * 0.9080);
    else if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() >= 20 &&
        indexSecondVertex - indexFirstVertex <= 4) // case6
      controlTwo = Offset(endPoint.dx + percentSegment2 * 0.9595,
          endPoint.dy + percentSegment2 * 1.9080);
    else if ((dataCurrency[indexFirstVertex] -
        dataCurrency[indexSecondVertex]).abs() <= 20 &&
        indexSecondVertex - indexFirstVertex >= 12) //case8
      controlTwo = Offset(endPoint.dx + percentSegment2 * 1.9595,
          endPoint.dy + percentSegment2 * 1.4080);
    else
      controlTwo = Offset(endPoint.dx + percentSegment2 * 1.9595,
          endPoint.dy + percentSegment2 * 1.4080);

    endPoint = Offset(indexSecondVertex * step,
        dataCurrency[indexSecondVertex]);

    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy, // control two
        endPoint.dx, endPoint.dy
    );

          //**************************SEGMENT 3**************************//
    segmentWidth = (indexRightPoint - indexSecondVertex) * step;
    double percentSegment3 = segmentWidth * 100 / sizeContainer.width; //percent of Segment2 of Container
    differenceValues = Offset(endPoint.dx - controlTwo.dx,
        endPoint.dy - controlTwo.dy);

    if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
                .abs() <=
            20 &&
        indexRightPoint - indexSecondVertex <= 4) // case2
      controlOne = Offset(endPoint.dx + differenceValues.dx / 17,
          endPoint.dy + differenceValues.dy / 13);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex >= 3 &&
        indexRightPoint - indexSecondVertex <= 4) // case3
      controlOne = Offset(endPoint.dx + differenceValues.dx / 5,
          endPoint.dy + differenceValues.dy / 5);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
                .abs() <=
            20 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case4
      controlOne = Offset(endPoint.dx + differenceValues.dx / 3,
          endPoint.dy + differenceValues.dy / 3);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        42 &&
        indexRightPoint - indexSecondVertex <= 4) // case5
      controlOne = Offset(endPoint.dx + differenceValues.dx / 7,
          endPoint.dy + differenceValues.dy / 23);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case6
      controlOne = Offset(endPoint.dx + differenceValues.dx / 2.7,
          endPoint.dy + differenceValues.dy / 4.3);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        42 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case7
      controlOne = Offset(endPoint.dx + differenceValues.dx / 3.7,
          endPoint.dy + differenceValues.dy / 4.3);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex == 2) // case8
      controlOne = Offset(endPoint.dx + differenceValues.dx / 5,
          endPoint.dy + differenceValues.dy / 5);
    else if (dataCurrency[indexSecondVertex] <= 15 &&
            indexRightPoint - indexSecondVertex >= 10 ||
        dataCurrency[indexRightPoint] <= 15 &&
            indexRightPoint - indexSecondVertex >= 10) // case9
      controlOne = Offset(endPoint.dx + differenceValues.dx / 2,
          endPoint.dy + differenceValues.dy / 7);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex == 1) // case10
      controlOne = Offset(endPoint.dx + differenceValues.dx / 10,
          endPoint.dy + differenceValues.dy / 10);
    else
      controlOne = Offset(
          endPoint.dx + differenceValues.dx, endPoint.dy + differenceValues.dy);

    //                               NEXT                                  //
    //                              CONTROL                                //
    //                               POINT                                 //

    if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
                .abs() <=
            20 &&
        indexRightPoint - indexSecondVertex <= 4) // case2
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 2.3277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 0.9722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
                .abs() >=
            21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
                .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex >= 3 &&
        indexRightPoint - indexSecondVertex <= 4) // case3
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.5277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 6.2722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() <=
        20 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case4
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.3277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 0.9722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        42 &&
        indexRightPoint - indexSecondVertex <= 4) // case5
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.5277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 2.2722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case6
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.7277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 2.2722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        42 &&
        indexRightPoint - indexSecondVertex >= 5 &&
        indexRightPoint - indexSecondVertex <= 9) // case7
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.5277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 3.7722);
    else if ((dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
        .abs() >=
        21 &&
        (dataCurrency[indexSecondVertex] - dataCurrency[indexRightPoint])
            .abs() <=
            41 &&
        indexRightPoint - indexSecondVertex <= 2) // case8
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 1.0277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 9.2722);
    else if (dataCurrency[indexSecondVertex] <= 15 &&
        indexRightPoint - indexSecondVertex >= 10 ||
        dataCurrency[indexRightPoint] <= 15 &&
            indexRightPoint - indexSecondVertex >= 10) // case9
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 2.4277,
        dataCurrency[indexSecondVertex] + percentSegment3 * 0.7722);
    else
      controlTwo = Offset(indexSecondVertex * step + percentSegment3 * 2.8277,
          dataCurrency[indexSecondVertex] + percentSegment3 * 0.7722);

    endPoint = Offset(indexRightPoint * step,
        dataCurrency[indexRightPoint]);
    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy,// control two
        endPoint.dx, endPoint.dy
    );

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
      if (copyData[copyData.length - 1] == double.infinity &&
          vertices.length == indexRightPoint - indexLeftPoint - 1) break;
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