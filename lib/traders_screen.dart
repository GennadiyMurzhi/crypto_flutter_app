import 'dart:math';

import 'package:crypto_flutter_app/currency_chart.dart';
import 'package:crypto_flutter_app/dashboard_screen.dart';
import 'package:crypto_flutter_app/data_exemple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TradersScreen extends StatefulWidget{
  @override
  _TradersScreenState createState() => _TradersScreenState();
}

class _TradersScreenState extends State<TradersScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Stack(
        children: [
          ListView(
              children: [
                SizedBox(height: 25,),
                TitleSection(),
                SizedBox(height: 10,),
                TradersSection(),
              ],
            ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 26),
        child: Row(
          children: [
            Text(
              "Traders",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
            ),
            Spacer(),
            MenuButton()
          ],
        )
      );
  }

}

class TradersSection extends StatefulWidget{
  @override
  _TradersSectionState createState() => _TradersSectionState();
}

class _TradersSectionState extends State<TradersSection>{
  DataExemple _data;
  List<double> _dataCurrency;
  List<String> _buttonsText = ["1H","12H","24H","2D","1W","1M","3M"];
  List<bool> _isActiveList = List.generate(7, (index) => index==2 ? true : false);
  DetailCurrencyChart chart;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DataExemple.createData();
    _dataCurrency = DataExemple.dataList[3];
    this.chart = DetailCurrencyChart(_dataCurrency, false);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 90,
          child: chart,
        ),
        SizedBox(height: 20,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: List.generate( 13, (index) => index % 2 != 0 ?
                Spacer()
                :
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: BoxDecoration(
                    color: _isActiveList[index~/2] ? Color.fromRGBO(14, 93, 205, 1)
                        : Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: _buttonsText[index~/2],
                      style: TextStyle(
                        fontSize: 14,
                        color: _isActiveList[index~/2] ? Colors.white
                            : Colors.grey[700],
                        fontWeight: _isActiveList[index~/2] ? FontWeight.bold
                            : FontWeight.normal
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = (){
                        if(_isActiveList[index~/2] == false) {
                          _dataCurrency = DataExemple.dataList[index ~/ 2];
                          for (int i = 0; i < _isActiveList.length; i++)
                            if (_isActiveList[i] == true)
                              _isActiveList[i] = false;
                          _isActiveList[index ~/ 2] = true;
                          setState(() {
                            this.chart = DetailCurrencyChart(_dataCurrency, true);
                          });
                        }
                      }
                    ),
                  ),
                )),
          ),
        )
      ],
    );
  }
}