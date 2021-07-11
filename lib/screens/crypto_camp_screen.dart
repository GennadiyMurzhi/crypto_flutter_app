import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../SizingTool.dart';

class CryptoCampScreen extends StatelessWidget{

  String userName = "Aurelijus Yen";
  DateTime lastLoggedDate = DateTime(2021,3,14);

  List<CryptoCampItem> menuItems = [   // while there is no screens there will be a dashboard
    CryptoCampItem("Dashboard", "/", 0),
    CryptoCampItem("Buy/Sell", "/testForm", 0),
    CryptoCampItem("Traders", "/traders", 0),
    CryptoCampItem("My Wallets", "/", 5),
    CryptoCampItem("Orders", "/", 0),
    CryptoCampItem("Converter", "/", 0),
  ];

  TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: 30,
    letterSpacing: -1,
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 45, 94, 1),
      body: Stack(
        children: [
          CustomPaint(
            painter: CryptoCampBackgroundPainter(),
            child: Container(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("CryptoCamp", style: style),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>
                            (Color.fromRGBO(0, 0, 0, 0)),
                          overlayColor: MaterialStateProperty.all<Color>
                            (Color.fromRGBO(1, 65, 112, 1)),
                          foregroundColor: MaterialStateProperty.all<Color>
                            (Color.fromRGBO(0, 210, 231, 1)),
                          shadowColor: MaterialStateProperty.all<Color>
                            (Color.fromRGBO(0, 0, 0, 0)),
                          shape: MaterialStateProperty.all<OutlinedBorder>
                            (CircleBorder()),
                          minimumSize: MaterialStateProperty.all<Size>
                            (Size.fromRadius(25)),
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 35,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 60,),
                SizedBox(
                  height: 347,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    separatorBuilder: (context, _) => SizedBox(height: 17,),
                    itemBuilder: (context, index){
                      if(menuItems[index]._countEvent > 0)
                        return MenuItemNotify(
                              titleItem: menuItems[index]._titleItem,
                              routeName: menuItems[index]._routeName,
                              styleItem: style,
                              countEvent: menuItems[index]._countEvent
                          );
                      else return MenuItem(
                        titleItem: menuItems[index]._titleItem,
                        routeName: menuItems[index]._routeName,
                        styleItem: style,
                      );
                    },
                  ),
                ),
                SizedBox(height: 80,),
                UserSection(userName: userName, lastLoggedDate: lastLoggedDate,),
                SizedBox(height: 40,),
                Text(
                  "CryptoCamp UI KIT\n© 2021 All rights reserved",
                  style: TextStyle(
                    color: Color.fromRGBO(69, 100, 134, 1),
                    fontSize: 11
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}

class MenuItem extends StatelessWidget{
  final String routeName;
  final String titleItem;
  final TextStyle styleItem;

  const MenuItem({Key key, this.routeName, this.titleItem, this.styleItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.only(top: 3),
      child: RichText(
        text: TextSpan(
          text: titleItem,
          style: styleItem,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.of(context).pushNamed(routeName);
            },
        ),
      ),
    );
  }

}

class MenuItemNotify extends StatefulWidget{
  final String routeName;
  final String titleItem;
  final TextStyle styleItem;
  final int countEvent;

  const MenuItemNotify({Key key, this.routeName, this.titleItem, this.styleItem, this.countEvent}) : super(key: key);
  @override
  _MenuItemNotifyState createState() => _MenuItemNotifyState(routeName, titleItem, styleItem, countEvent);
}

class _MenuItemNotifyState extends State<MenuItemNotify>{
  final String routeName;
  final String titleItem;
  final TextStyle styleItem;
  final int countEvent;

  _MenuItemNotifyState(this.routeName, this.titleItem, this.styleItem, this.countEvent);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(children: [
      MenuItem(
        routeName: routeName,
        titleItem: titleItem,
        styleItem: styleItem,
      ),
      Positioned(
        left: 142,
        bottom: 23,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color.fromRGBO(0, 215, 235, 1)),
          child: Text(
            countEvent.toString(),
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ),
      )
    ]);
  }
}

class CryptoCampItem {
  String _titleItem;
  String _routeName;
  int _countEvent;

  CryptoCampItem(this._titleItem, this._routeName, this._countEvent);
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

class UserSection extends StatelessWidget{
  final String userName;
  final DateTime lastLoggedDate;

  const UserSection({Key key, this.userName, this.lastLoggedDate}) : super(key: key);@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              child: Image(
                image: AssetImage("resource/images/ava.jpg"),
                height: 45,
                width: 45,
              ),
            ),
            SizedBox(width: 10,),
            SizedBox(
              height: 46,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(184, 191, 207, 1)
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Last logged in " + lastLoggedDate.day.toString() + "/" +
                      lastLoggedDate.month.toString() + "/" +
                        lastLoggedDate.year.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(107, 130, 141, 1)
                    ),
                  )
                ],
              ),
            ),
            Spacer(),
            RichText(text: TextSpan(
              text: "LOG OUT",
              style: TextStyle(
                fontSize: 14,
                color: Color.fromRGBO(184, 191, 207, 1),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = (){
                  Navigator.pushNamed(context, "/sign_in");
                }
            ))
          ],
        ),
        SizedBox(height: 5,),
        Container(height: 3, color: Color.fromRGBO(17, 70, 110, 1))
      ],
    );
  }
}