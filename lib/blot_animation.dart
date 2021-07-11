import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlotAnimation extends StatefulWidget{
  final double minRadius;
  final double maxRadius;
  final int userSegmentsCount;


  const BlotAnimation({Key key, this.minRadius, this.maxRadius,
    this.userSegmentsCount}) : super(key: key);
  @override
  _BlotAnimationState createState() => _BlotAnimationState(minRadius, maxRadius, userSegmentsCount);
}

class _BlotAnimationState extends State<BlotAnimation>
    with BlotCalculationTools, SingleTickerProviderStateMixin {

  final double minRadius;
  final double maxRadius;
  final int userSegmentsCount;

  int _subsegmentCount;
  double _distanceBetweenPoints;
  List<List<Offset>> _points; //points are used to create circle
  List<List<Offset>> _vectors; //vectors are used to change circle to blot
  List<bool> _subsegmentsStatus;


  _BlotAnimationState(this.minRadius, this.maxRadius, this.userSegmentsCount){
    _subsegmentCount = getSubsegmentCount(userSegmentsCount);
    _distanceBetweenPoints = getDistanceBetweenPoints(minRadius,
        _subsegmentCount);
    _points = getPoints(getFirstPoint(minRadius), getBasis(minRadius),
        _distanceBetweenPoints, _subsegmentCount);
    _vectors = getPoints(getFirstVector(maxRadius), Offset.zero,
        _distanceBetweenPoints, _subsegmentCount);
    _subsegmentsStatus = List.generate(_subsegmentCount, (index) => true);
  }

  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_,__){
        return CustomPaint(
          painter: BlotAnimationPainter(_subsegmentCount, _points, _vectors),
          child: Container(
            width: minRadius * 2 * _animationController.value,
            height: minRadius * 2 * _animationController.value,
          ),
        );
      },
    );
  }

}

class BlotAnimationPainter extends CustomPainter{
  final int subSegmentsCount;
  final List<List<Offset>> points;
  final List<List<Offset>> vectors;

  BlotAnimationPainter(this.subSegmentsCount, this.points, this.vectors);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Path path = Path();
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeWidth = 3.5;

    //the path must be started from the first starting point. The end point of
    //the last subsegment is also the start point of the first subsegment
    path.moveTo(points[points.length-1][2].dx, points[points.length-1][2].dy);
    for(int i = 0; i <= subSegmentsCount - 1; i++)
      path.cubicTo(
          points[i][0].dx, points[i][0].dy,
          points[i][1].dx, points[i][1].dy,
          points[i][2].dx, points[i][2].dy
      );

    canvas.drawPath(path, paint);

    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}

class BlotCalculationTools{
  static const int sOneV = 6; //number of subsegments for one vertex

  Offset getFirstPoint(double minRadius) => Offset(0, 0 - minRadius); //get firstPoint without basis

  Offset getFirstVector(double maxRadius) => Offset(0, 0 - maxRadius); //get vector for changes for firstPoint

  Offset getBasis(double minRadius) => Offset(minRadius, minRadius);

  int getSubsegmentCount(int userSegmentsCount) => userSegmentsCount * 2;

  int getVertexesCount(int subsegmentCount) => subsegmentCount~/sOneV;

  int getFreeSegments(int subsegmentCount) =>
      subsegmentCount - getVertexesCount(subsegmentCount) * sOneV;

  int getStartSubsegment(int subsegmentCount) =>
      Random().nextInt(subsegmentCount - 1);


  ///this method get distance between start and first control point,
  ///and control point two without rotate. For radius accept Y-axis
  ///_firstStartPoint
  double getDistanceBetweenPoints(double radius, int countSubSegments){
    return radius * (4/3) * tan(pi/(2 * countSubSegments));
  }

  ///this method rotate point, and smooth out with basis
  Offset _rotatePoint (Offset point, Offset basis, double angle){
    return Offset(basis.dx + point.dx * cos(angle) - point.dy * sin(angle),
        basis.dy + point.dx * sin(angle) + point.dy * cos(angle));
  }

  ///this method return list of rotate points to build figure segments via cubicTo.
  ///firstControlPoint does not need to rotate, because
  ///firstControlPointWithoutRotate matches with firstControlPoint.
  ///List points understand:
  ///[0][0] - Segment first control point
  ///[0][1] - Segment second control point
  ///[0][2] - Segment end point
  List<List<Offset>> getPoints(Offset firstStartPoint, Offset basis,
      double distance, int countSubsegments){
    Offset firstControlPointWithoutRotate =
    Offset(firstStartPoint.dx + distance, firstStartPoint.dy);
    Offset secondControlPointWithoutRotate =
    Offset(firstStartPoint.dx - distance, firstStartPoint.dy);
    double rotateAngle = 2 * pi / countSubsegments;

    List<List<Offset>> points =
        List.generate(countSubsegments, (index) => List<Offset>(3));

    points[0][0] = Offset(firstControlPointWithoutRotate.dx + basis.dx,
        firstControlPointWithoutRotate.dy + basis.dy);
    points[0][1] = _rotatePoint(secondControlPointWithoutRotate, basis, rotateAngle);
    points[0][2] = _rotatePoint(firstStartPoint, basis, rotateAngle);

    // the firstControlPoint of th first segment is initially found easily by
    // displacement by a distance along the X-axis, while in order to find the
    // secondControlPoint, you need to rotate, also in order to find the endPoint
    // itself. Therefore, to find the points of the next segments, the rotation
    // angle of the secondControlPoint and the endPoint must be one step more
    // than the firstControlPoint.
    for(int i = 1; i <= countSubsegments - 1; i++){
      points[i][0] = _rotatePoint(
          firstControlPointWithoutRotate, basis, rotateAngle * i);
      points[i][1] = _rotatePoint(
          secondControlPointWithoutRotate, basis, rotateAngle * (i + 1));
      points[i][2] = _rotatePoint(
          firstStartPoint, basis, rotateAngle * (i + 1));
    }

    return points;
  }

  int getFirstFreeIndex(
      List<bool> subsegmentsStatus, int lastIndexVertexesGroup) {
    int loop(
        List<bool> subsegmentsStatus, lastIndexVertexesGroup, bool clockwise) {
      int startIndex;
      if (clockwise) {
        int c = 0;
        for (int i = lastIndexVertexesGroup;
            c <= subsegmentsStatus.length - 1 - lastIndexVertexesGroup;
            i++ + c++) {
          if(i == subsegmentsStatus.length) i = 0;
          if (i + sOneV > subsegmentsStatus.length - 1) { //in case of going to the beginning of the list
            int iteration2Count = i + sOneV - subsegmentsStatus.length - 1; // how many iteration are left/fit
            int iteration1Count = sOneV - iteration2Count;
            for (int k = i; k <= subsegmentsStatus.length - 1; k++) {
              if (subsegmentsStatus[k] == false) {
                break;
              } else if (k == subsegmentsStatus.length - 1) {
                for (int j = 0; j <= iteration2Count; j++) {
                  if (subsegmentsStatus[j] == false) {
                    break;
                  } else if(j == iteration2Count && subsegmentsStatus[j] == true){
                    startIndex = i;
                  }
                }
              }
            }
          } else for(int k = i; k <= i + sOneV - 1; k++){
            if(subsegmentsStatus[k] == false) break;
            else if(subsegmentsStatus[k] == true && k == i + sOneV - 1)
              startIndex = i;
          }
        }
      } else {
        int c = 0;
        for (int i = lastIndexVertexesGroup;
        c <= subsegmentsStatus.length - 1 - lastIndexVertexesGroup;
        i-- + c--) {
          if(i == 0) i = subsegmentsStatus.length;
          if (i - sOneV < 0) { //in case of going to the beginning of the list //
            int iteration2Count = i + sOneV - subsegmentsStatus.length - 1; // how many iteration are left/fit
            int iteration1Count = sOneV - iteration2Count;
            for (int k = i; k <= subsegmentsStatus.length - 1; k++) {
              if (subsegmentsStatus[k] == false) {
                break;
              } else if (k == subsegmentsStatus.length - 1) {
                for (int j = 0; j <= iteration2Count; j++) {
                  if (subsegmentsStatus[j] == false) {
                    break;
                  } else if(j == iteration2Count && subsegmentsStatus[j] == true){
                    startIndex = i;
                  }
                }
              }
            }
          } else for(int k = i; k <= i + sOneV - 1; k++){
            if(subsegmentsStatus[k] == false) break;
            else if(subsegmentsStatus[k] == true && k == i + sOneV - 1)
              startIndex = i;
          }
        }
      }
      return startIndex;
    }
  }
}
