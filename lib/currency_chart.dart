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
      if(vertices.length == 4){
        drawContactBlueCurve(canvas, indexLeftPoint, indexRightPoint, vertices[0],
            vertices[3], size);
        drawContactOrangeCurve(canvas, indexLeftPoint, indexRightPoint,
            vertices[0], vertices[2], vertices[3], size);
        /*drawContactLightBlueCurve(canvas, indexLeftPoint, indexRightPoint,
            vertices[1], vertices[2], size.width);*/
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

  void drawContactBlueCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexFirstVertex, int indexFourthVertex, Size sizeContainer){
    var paint = Paint()
        ..color = Color.fromRGBO(55, 107, 207, 1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

    double step = getStep(dataCurrency, sizeContainer.width);
    //(absciss or ordinat control point design *100 / widthSpline design) / 100

    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint]);
    double segmentWidth = (indexFirstVertex - indexLeftPoint) * step;
    double percentSegment1 = segmentWidth * 100 / sizeContainer.width; //percent of Segment1 of Container

    //spline 1
    Offset controlOne = Offset(
        indexLeftPoint * step + percentSegment1 * 0.4375,
        dataCurrency[indexLeftPoint] + percentSegment1 * 1.0842);
    Offset controlTwo;
    if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex] &&
        dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]
            > (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 2 &&
        indexFirstVertex - indexLeftPoint < 3)
      controlTwo = Offset(
          indexLeftPoint * step + percentSegment1 * 1.9527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 0.575);
    else if(dataCurrency[indexLeftPoint]<dataCurrency[indexFirstVertex])
      controlTwo = Offset(
          indexLeftPoint * step + percentSegment1 * 0.7527,
          dataCurrency[indexLeftPoint] - percentSegment1 * 0.875
      );
    else controlTwo = Offset(
        indexLeftPoint * step + percentSegment1 * 0.7527,
        dataCurrency[indexLeftPoint] + percentSegment1 * 0.875
    );
    Offset endPoint = Offset(indexFirstVertex * step,
        dataCurrency[indexFirstVertex]);

    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy, // control two
        endPoint.dx, endPoint.dy
    );
    //spline 2
    segmentWidth = (indexFourthVertex - indexFirstVertex) * step;
    double percentSegment2 = segmentWidth * 100 / sizeContainer.width; //percent of Segment2 of Container
    Offset differenceValues = Offset(endPoint.dx - controlTwo.dx,
        endPoint.dy - controlTwo.dy);
    /*if(dataCurrency[indexFirstVertex] > dataCurrency[indexFourthVertex])
      controlOne = Offset(endPoint.dx + differenceValues.dx,
          endPoint.dy + differenceValues.dy);
    else controlOne = Offset(endPoint.dx + differenceValues.dx,
        endPoint.dy + differenceValues.dy);
    print("difference currency "+(dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]).toString());
    print("difference indexes indexFirstVertex - indexLeftPoint "+(indexFirstVertex - indexLeftPoint).toString());
    print("average currency "+((dataCurrency.reduce(max)
        + dataCurrency.reduce(min)) / 2).toString());*/
    if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex] &&
        dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]
            > (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 2 &&
        indexFirstVertex - indexLeftPoint > 5)
      controlOne = Offset(endPoint.dx + percentSegment1 * 1.3527,
        endPoint.dy - percentSegment1 * 1.175);
    else if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex] &&
        dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]
            > (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 2 &&
        indexFirstVertex - indexLeftPoint < 5 &&
        indexFirstVertex - indexLeftPoint > 2)
      controlOne = Offset(endPoint.dx + percentSegment1 * 2.1527,
        endPoint.dy - percentSegment1 * 2.575);
    else if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex] &&
        dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]
            > (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 2 &&
        indexFirstVertex - indexLeftPoint < 3)
      controlOne = Offset(endPoint.dx + percentSegment1 * 3.1527,
          endPoint.dy - percentSegment1 * 5.575);
    else if(dataCurrency[indexLeftPoint] > dataCurrency[indexFirstVertex] &&
        dataCurrency[indexLeftPoint] - dataCurrency[indexFirstVertex]
            < (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 2 &&
        indexFirstVertex - indexLeftPoint < 3)
      controlOne = Offset(endPoint.dx + percentSegment1 * 9.1527,
          endPoint.dy - percentSegment1 * 11.575);
    else controlOne = Offset(endPoint.dx + differenceValues.dx,
          endPoint.dy + differenceValues.dy);
    if(indexRightPoint - indexFourthVertex == 1 &&
        (dataCurrency[indexRightPoint] - dataCurrency[indexFourthVertex]).abs()
            < (dataCurrency.reduce(max) + dataCurrency.reduce(min)) / 4)
    controlTwo = Offset(indexFirstVertex * step + percentSegment2 * 1.9595,
        dataCurrency[indexFirstVertex] + percentSegment2 * 1.0080);
    else controlTwo = Offset(indexFirstVertex * step + percentSegment2 * 1.9595,
        dataCurrency[indexFirstVertex] + percentSegment2 * 1.4080);
    endPoint = Offset(indexFourthVertex * step,
        dataCurrency[indexFourthVertex]);
    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy,// control two
        endPoint.dx, endPoint.dy
    );
    //spline 3
    segmentWidth = (indexRightPoint - indexFourthVertex) * step;
    double percentSegment3 = segmentWidth * 100 / sizeContainer.width; //percent of Segment2 of Container
    differenceValues = Offset(endPoint.dx - controlTwo.dx,
        endPoint.dy - controlTwo.dy);
    /*print("difference indexes indexRightPoint - indexFourthVertex "+(indexRightPoint - indexFourthVertex).toString());
    print("difference currency "+(dataCurrency[indexRightPoint] - dataCurrency[indexFourthVertex]).toString());*/
    if(indexRightPoint - indexFourthVertex == 1)
      controlOne = Offset(endPoint.dx + percentSegment3 * 0.9595,
          endPoint.dy - percentSegment3 * 0.3580);
    else if(indexRightPoint - indexFourthVertex > 5)
      controlOne = Offset(endPoint.dx + percentSegment3 * 0.3595,
        endPoint.dy - percentSegment3 * 0.2080);
    else controlOne = Offset(endPoint.dx + percentSegment3 * 1.9595,
        endPoint.dy - percentSegment3 * 1.4080);
    if(dataCurrency[indexFourthVertex] > dataCurrency[indexRightPoint])
        controlTwo = Offset(indexFourthVertex * step + percentSegment3 * 2.8277,
            dataCurrency[indexFourthVertex] + percentSegment3 * 1.7722);
    else controlTwo = Offset(indexFourthVertex * step + percentSegment3 * 2.8277,
        dataCurrency[indexFourthVertex] - percentSegment3 * 1.7722);
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

  void drawContactOrangeCurve(Canvas canvas, int indexLeftPoint, int indexRightPoint,
      int indexFirstVertex, int indexThirdVertex, int indexFourthVertex, Size sizeContainer){
    var paint = Paint()
      ..color = Color.fromRGBO(235, 187, 195, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double step = getStep(dataCurrency, sizeContainer.width);

    var path = Path()
      ..moveTo(indexLeftPoint * step, dataCurrency[indexLeftPoint]);

    double segmentWidth = (indexFirstVertex - indexLeftPoint) * step;
    double percentSegment1 = segmentWidth * 100 / sizeContainer.width;

    //segment 1
    Offset controlOne = Offset(
        indexLeftPoint * step + percentSegment1 * 0.6459 ,
        dataCurrency[indexLeftPoint] + percentSegment1 * 1.4324 );
    Offset controlTwo = Offset(
        indexLeftPoint * step + percentSegment1 * 0.6648 ,
        dataCurrency[indexLeftPoint] + percentSegment1 * 0.9702 );
    Offset endPoint = Offset(indexFirstVertex * step,
        dataCurrency[indexFirstVertex]);
    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy,// control two
        endPoint.dx, endPoint.dy
    );
    //segment 2
    segmentWidth = (indexThirdVertex - indexFirstVertex) * step;
    double percentSegment2 = segmentWidth * 100 / sizeContainer.width; //percent of Segment2 of Container
    Offset differenceValues = Offset(endPoint.dx - controlTwo.dx,
        endPoint.dy - controlTwo.dy);
    controlOne = Offset(endPoint.dx + differenceValues.dx,
        endPoint.dy + differenceValues.dy);
    controlTwo = Offset(
        endPoint.dx + percentSegment2 * 1.6296,
        endPoint.dy + percentSegment2 * 2.1407 );
    endPoint = Offset(indexThirdVertex * step,
        dataCurrency[indexThirdVertex]);
    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy,// control two
        endPoint.dx, endPoint.dy
    );

    //segment 3
    segmentWidth = (indexFourthVertex - indexThirdVertex) * step;
    double percentSegment3= segmentWidth * 100 / sizeContainer.width;
    if(indexFourthVertex - indexThirdVertex <= 2 &&
        dataCurrency[indexFourthVertex] > dataCurrency[indexThirdVertex])
      controlOne = Offset(endPoint.dx + (percentSegment3 * 1.9) * 1.6296,
          endPoint.dy + (percentSegment3 * 0.5) * 2.1407);
    else if(indexFourthVertex - indexThirdVertex <= 2 &&
        dataCurrency[indexFourthVertex] < dataCurrency[indexThirdVertex])
      controlOne = Offset(endPoint.dx + (percentSegment3 * 1.9) * 1.6296,
          endPoint.dy - (percentSegment3 * 0.5) * 2.1407);
    else if(dataCurrency[indexFourthVertex] > dataCurrency[indexThirdVertex])
        controlOne = Offset(endPoint.dx + percentSegment3 * 1.6296,
            endPoint.dy + percentSegment3 * 2.1407);
    else controlOne = Offset(endPoint.dx + percentSegment3 * 1.6296,
        endPoint.dy - percentSegment3 * 2.1407);

    if(indexFourthVertex - indexThirdVertex <= 2 &&
        dataCurrency[indexFourthVertex] > dataCurrency[indexThirdVertex])
      controlTwo = Offset(indexFourthVertex * step - (percentSegment3 * 0.9)* 4.5 ,
          dataCurrency[indexFourthVertex] - (percentSegment3 * 0.5)* 3.6686);
    else if(indexFourthVertex - indexThirdVertex <= 2 &&
        dataCurrency[indexFourthVertex] < dataCurrency[indexThirdVertex])
      controlTwo = Offset(indexFourthVertex * step - (percentSegment3 * 0.9)* 4.5 ,
          dataCurrency[indexFourthVertex] + (percentSegment3 * 0.5)* 3.6686);
    else controlTwo = Offset(
        endPoint.dx + (percentSegment3 - step)* 4.5 ,
        endPoint.dy + (percentSegment3 - step)* 3.6686);
    endPoint = Offset(indexFourthVertex * step,
        dataCurrency[indexFourthVertex]);
    path.cubicTo(
        controlOne.dx, controlOne.dy, //control one
        controlTwo.dx, controlTwo.dy,// control two
        endPoint.dx, endPoint.dy
    );

    //segment 4
    segmentWidth = (indexRightPoint - indexFourthVertex) * step;
    double percentSegment4 = segmentWidth * 100 / sizeContainer.width;
    if(indexRightPoint - indexFourthVertex > 9)
      controlOne = Offset(endPoint.dx + (percentSegment4 - step * 2)  * 4.5,
          endPoint.dy - (percentSegment4 - step * 3.5) * 3.6686);
    else if(indexRightPoint - indexFourthVertex > 7)
      controlOne = Offset(endPoint.dx + percentSegment4  * 4.5,
          endPoint.dy - (percentSegment4 - step) * 3.6686);
    else controlOne = Offset(endPoint.dx + percentSegment4  * 4.5,
        endPoint.dy - percentSegment4 * 3.6686);

    if(indexRightPoint - indexFourthVertex > 9)
      controlTwo = Offset(endPoint.dx + percentSegment4 * 2.5378 ,
          endPoint.dy + (percentSegment4 - step) * 1.3810 );
    else if(indexRightPoint - indexFourthVertex > 7)
      controlTwo = Offset(endPoint.dx + percentSegment4 * 2.5378 ,
          endPoint.dy + percentSegment4 * 1.3810 );
    else if(dataCurrency[indexFourthVertex] < dataCurrency[indexRightPoint])
      controlTwo = Offset(endPoint.dx + percentSegment4 * 2.5378 ,
          endPoint.dy + percentSegment4 * 1.3810 );
    else controlTwo = Offset(endPoint.dx + percentSegment4 * 2.5378 ,
        endPoint.dy - percentSegment4 * 1.3810 );
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
      if(indexRightPoint - indexLeftPoint < 4
          && vertices.length == indexRightPoint - indexLeftPoint - 1) break;
      if (copyData[copyData.length - 1] == double.infinity && vertices.length == 4) break;
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