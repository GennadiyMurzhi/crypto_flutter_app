

import 'dart:math';

import 'package:crypto_flutter_app/crypto_app_icons_icons.dart';
import 'package:crypto_flutter_app/currency_chart.dart';
import 'package:crypto_flutter_app/logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SizingTool.dart';

class DashboardScreen extends StatefulWidget{
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Sizing.setSize(Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));


    Sizing sizing = Sizing().getInstence();
    print(sizing.getValue(15).toString() + " " + sizing.getValue(20).toString() + " " + sizing.getValue(10).toString());
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: ListView(
        children: [
          DashboardTopSection(),
          ActivitySection(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                children: [
                  IOTASection(),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: LitecoinSection(),
                  )
                ]
            )
          ),

        ],
      ),
    );
  }
}



class DashboardTopSection extends StatelessWidget{
  int blueCurrencyEquivalent = 35785;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(26, 25, 26, 17),
      height: 225,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(17)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 3)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: Container()),
            IconButton(
              iconSize: 34,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(0),
              icon: Icon(Icons.menu),
            )
          ]),
          Padding(
            padding: EdgeInsets.only(top: 11, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  child: Icon(
                    CryptoAppIcons.bitcoin,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Color.fromRGBO(255, 172, 1, 1)),
                ),
                Expanded(child: Container()),
                RedPercentageNearCurrency(percentage: 1.451,)
              ],
            ),
          ),
          BigCurrency(number: 0.423190633,),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.lightBlue[700],
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                text: '\$',
                children: [
                  TextSpan(
                    text: parsNumber(blueCurrencyEquivalent)
                  )
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  String parsNumber(int number){
    String stringNumber = number.toString();
    String finishString;
    int quantityIterations = stringNumber.length - 1;

    for(int i = 0; i <= quantityIterations; i++){
      if(i == 0) {
        finishString = '.' + stringNumber[quantityIterations];
        continue;
      }
      if(i % 3 == 0) finishString = '.' + stringNumber[quantityIterations - i]
          + finishString;
      else finishString = stringNumber[quantityIterations - i] + finishString;
    }
    return finishString;
  }
}

class RedPercentageNearCurrency extends StatelessWidget{
  final double percentage;

  const RedPercentageNearCurrency({Key key, this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            text: percentage.toString(),
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.5
            ),
            children: [
              TextSpan(text: '% ')
            ]
          ),
        ),
        Icon(CryptoAppIcons.down_dir, color: Colors.red, size: 18)
      ],
    );
  }

}

class BigCurrency extends StatelessWidget{
  final double number;

  const BigCurrency({Key key, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: -1
        ),
        text: number.toString(),
        children: [
          TextSpan(text: " BTC")
        ]
      ),
    );
  }

}

class ActivitySection extends StatelessWidget{
  final List<ActivityEvent> lastThreeEvents = [
    ActivityEvent(
      isIncoming: false,
      titleEvent: "Sent Bitcoin",
      commentEvent: "To Ethereum address",
      amount: -0.003421,
      currency: "BTC",
    ),
    ActivityEvent(
      isIncoming: false,
      titleEvent: "Sent Bitcoin",
      commentEvent: "To Ethereum address",
      amount: -0.003421,
      currency: "BTC",
    ),
    ActivityEvent(
      isIncoming: false,
      titleEvent: "Sent Bitcoin",
      commentEvent: "To Ethereum address",
      amount: -0.003421,
      currency: "BTC",
    )
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(26, 30, 26, 15),
      child: Column(
        children: [
          activityTitle(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: lastThreeEvents.length,
            itemBuilder: (_, index) => lastThreeEvents[index],
          )
        ],
      ),
    );
  }

  Widget activityTitle(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        "Activity",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),
      ),
    );
  }
}

class ActivityEvent extends StatelessWidget{
  final bool isIncoming;
  final String titleEvent;
  final String commentEvent;
  final double amount;
  final String currency;

  const ActivityEvent(
      {Key key,
      this.isIncoming,
      this.titleEvent,
      this.commentEvent,
      this.amount,
      this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Row(
          children: [
            Icon(
              isIncoming ? CryptoAppIcons.up_circle : CryptoAppIcons.down_circle,
              color: isIncoming ? Colors.grey : Colors.red,
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleEvent,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                    commentEvent,
                  style: TextStyle(
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 40,
                alignment: Alignment.topRight,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black
                    ),
                    text: amount.toString(),
                    children: [TextSpan(text: currency)]
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
        SizedBox(height: 17)
      ],
    );
  }
}

class IOTASection extends StatelessWidget{
  double rates = 1.38;
  double amount = 519.47;
  double coins = 278.4;

  TextStyle styleUp = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15
  );
  TextStyle styleDown = TextStyle(
      color: Colors.grey[600],
      fontSize: 12
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 3)
          ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22, horizontal: 17),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Color.fromRGBO(67, 67, 67, 1),
                gradient: RadialGradient(
                  radius: 0.3,
                  colors: [
                    Color.fromRGBO(110, 110, 110, 1),
                    Color.fromRGBO(100, 100, 100, 1),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(9))
              ),
              child: Icon(CryptoAppIcons.iota, size: 19, color: Colors.grey[200],),
            ),
            SizedBox(width: 17,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("IOTA", style: styleUp,),
                SizedBox(height: 7,),
                RichText(
                  text: TextSpan(
                      style: styleDown,
                      text: "\$",
                      children: [
                        TextSpan(text: rates.toString())
                      ]
                  ),
                )
              ],
            ),
            SizedBox(width: 50,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      style: styleUp,
                      text: "\$",
                      children: [
                        TextSpan(text: amount.toString())
                      ]
                  ),
                ),
                SizedBox(height: 7,),
                RichText(
                  text: TextSpan(
                      style: styleDown,
                      text: coins.toString(),
                      children: [
                        TextSpan(text: "Coins")
                      ]
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LitecoinSection extends StatelessWidget{

  TextStyle styleUp = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 15
  );
  TextStyle styleDown = TextStyle(
      color: Colors.grey[600],
      fontSize: 12
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 3)
          ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 22),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(67, 67, 67, 1),
                        gradient: RadialGradient(
                          radius: 0.9,
                          colors: [
                            Color.fromRGBO(230, 230, 230, 0.5),
                            Color.fromRGBO(230, 230, 230, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(9))
                    ),
                    child: Icon(
                      CryptoAppIcons.litecoin,
                      size: 27,
                      color: Color.fromRGBO(189, 189, 189, 1),
                    ),
                  ),
                  SizedBox(width: 17,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Litecoine", style: styleUp,),
                      SizedBox(height: 7,),
                      RichText(
                        text: TextSpan(
                            style: styleDown,
                            text: "\$",
                            children: [
                              TextSpan(text: 138.27.toString())
                            ]
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(
                        height: 40,
                        alignment: Alignment.topRight,
                        child: RedPercentageNearCurrency(percentage: 15.6,)
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              width: double.maxFinite,
              padding: EdgeInsets.only(top: 20),
              child: CurrencyChart(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                      text: "Rank",
                      children: [
                        TextSpan(text: "   "),
                        TextSpan(
                          style: TextStyle(
                            fontSize: 36
                          ),
                          text: 7.toString(),
                        )
                      ]
                    )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Portfolio Quota",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12
                                  ),
                                ),
                                Text(
                                  48.toString() + "%",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 15,),
                            CircleProgress(48)
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleProgress extends StatelessWidget{
  final double percent;

  CircleProgress(this.percent);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 2
            ),
            shape: BoxShape.circle
          ),
        ),
        CustomPaint(
          painter: CircleProgressPainter(percent),
          child: Container(
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }


}

class CircleProgressPainter extends CustomPainter{
  final double percent;

  CircleProgressPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.lightBlue[800];

    var path = Path()
      ..moveTo(size.width/2, size.height);

    path.addArc(
        Rect.fromCenter(
            center: Offset(size.width/2, size.height/2),
            width: size.width,
            height: size.height
        ),
        1.5*pi,
        2 * pi / 100 * percent
    );
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