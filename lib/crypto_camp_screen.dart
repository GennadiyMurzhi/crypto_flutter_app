import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'SizingTool.dart';

class CryptoCampScreen extends StatelessWidget{

  TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 24,
    letterSpacing: -5,
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 45, 94, 1),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 45, horizontal: 25),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("CryptoCamp", style: style),
                    Expanded(),
                    ElevatedButton(
                      onPressed: (){},
                      child: Icon(
                        Icons.close,
                        size: 24,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 120,),
                MenuItem(
                  titleItem: "",
                  routeName: "",
                  styleItem: style,
                  countEvent: 0,
                )
              ],
            ),
          ),
          CustomPaint(
            painter: CryptoCampBackgroundPainter(),
            child: Container(),
          ),
        ],
      ),
    );
  }
  
}

class CryptoCampBackgroundPainter extends CustomPainter{

  var sizing = Sizing().getInstence();

  @override
  void paint(Canvas canvas, Size size) {
    Sizing.setSize(size);

    var paint = Paint()
      ..color = Color.fromRGBO(1, 55, 102, 1)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(size.width, sizing.getValue(103.38))
      ..arcToPoint(Offset(sizing.getValue(131.5), 0), radius: Radius.circular(sizing.getValue(80)))
      ..lineTo(sizing.getValue(86.5), 0)
      ..arcToPoint(Offset(size.width, sizing.getValue(148)), radius: Radius.circular(sizing.getValue(122.5)), clockwise: false)
      ..close();
    
    canvas.drawPath(path, paint);
    canvas.save();
    canvas.restore();
    
    path.reset();
    path.moveTo(size.width, sizing.getValue(176.33));
    path.arcToPoint(Offset(sizing.getValue(58.17), 0), radius: Radius.circular(sizing.getValue(153)));
    path.lineTo(sizing.getValue(14.5), 0);
    path.arcToPoint(Offset(size.width,sizing.getValue(217)), radius: Radius.circular(sizing.getValue(190)),clockwise: false);
    path.close();

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

class MenuItem extends StatefulWidget{
  final String routeName;
  final String titleItem;
  final TextStyle styleItem;
  final double countEvent;

  const MenuItem({Key key, this.routeName, this.titleItem, this.styleItem, this.countEvent}) : super(key: key);
  @override
  _MenuItemState createState() => _MenuItemState(routeName, titleItem, styleItem, countEvent);
}

class _MenuItemState extends State<MenuItem>{
  final String routeName;
  final String titleItem;
  final TextStyle styleItem;
  final double countEvent;

  _MenuItemState(this.routeName, this.titleItem, this.styleItem, this.countEvent);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      RichText(
        text: TextSpan(
          text: titleItem,
          style: styleItem,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, routeName);
            },
        ),
      ),
      Container(
        width: 10,
        height: 5,
        margin: EdgeInsets.only(left: -5, top: -10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Color.fromRGBO(0, 215, 235, 1)
        ),
        child: Text(
          countEvent.toString(),
          style: TextStyle(fontSize: 3, color: Colors.white),
        ),
      )
    ]);
  }
}