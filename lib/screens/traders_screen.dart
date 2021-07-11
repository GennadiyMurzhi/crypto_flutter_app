import 'package:crypto_flutter_app/currency_chart.dart';
import 'package:crypto_flutter_app/processing_data.dart';
import 'package:crypto_flutter_app/screens/dashboard_screen.dart';
import 'package:crypto_flutter_app/data_exemple.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../blot_animation.dart';

class TradersScreen extends StatefulWidget{
  @override
  _TradersScreenState createState() => _TradersScreenState();
}

class _TradersScreenState extends State<TradersScreen>{
  EdgeInsets _symmetricPadding = EdgeInsets.symmetric(horizontal: 35);

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
                TradersSection(symmetricPadding: _symmetricPadding,),
                SizedBox(height: 20,),
                SplitSection(symmetricPadding: _symmetricPadding,)
              ],
            ),
        ],
      ),
    );
  }
}

class SplitSection extends StatelessWidget{
  final EdgeInsets symmetricPadding;

  const SplitSection({Key key, this.symmetricPadding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: symmetricPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Investment Split",
            style: TextStyle(
              fontFamily: "FredokaOne",
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 7,),
          Text(
            "Showcase of how account Investment Split between coins",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.grey
            ),
          ),
          SizedBox(height: 20,),
          SizedBox(//investment split animation
            width: double.infinity,
            height: 200,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 10,
                      color: Colors.blue[800].withOpacity(0)
                    )
                  ),
                  child: Align(
                    child: Text(
                      " " +
                          ProcessingData.sortedCurrencyPercentValue(
                                  DataExemple.currencyPercentValue)
                              .values
                              .elementAt(0)
                              .toString() +
                          "%",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                BlotAnimation(minRadius: 60, userSegmentsCount: 8, maxRadius: 120,)
              ],
            ),
          ),
          SizedBox(height: 20,),
          CurrencyInPercent(currencyStatus: ProcessingData
              .sortedCurrencyPercentValue(DataExemple.currencyPercentValue),)
        ],
      ),
    );
  }
}

class CurrencyInPercent extends StatefulWidget{
  final Map<String, int> currencyStatus;

  const CurrencyInPercent({Key key, this.currencyStatus}) : super(key: key);
  @override
  _CurrencyInPercentState createState() => _CurrencyInPercentState(currencyStatus);
}

class _CurrencyInPercentState extends State <CurrencyInPercent>{
  final Map<String, int> currencyStatus;

  _CurrencyInPercentState(this.currencyStatus);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children:
        List.generate(5, (index) => index % 2 != 0 ?
        Spacer()
        :
        SingleCurrencyWithPercent(
            percent: currencyStatus.values.elementAt(index~/2),
            nameCurrency: currencyStatus.keys.elementAt(index~/2),
            color: DataExemple.currencyColor[currencyStatus.keys.elementAt(index~/2)],
          )
        )
      ,
    );
  }

}

class SingleCurrencyWithPercent extends StatelessWidget{

  final int percent;
  final String nameCurrency;
  final Color color;

  const SingleCurrencyWithPercent({Key key, this.percent, this.nameCurrency,
    this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            //color: color,
            shape: BoxShape.circle,
            gradient: RadialGradient(
              radius: 0.5,
              colors: [
                color.withOpacity(0.5),
                color
              ]
            )
          ),
        ),
        SizedBox(width: 5,),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            children: [
              TextSpan(text: percent.toString()),
              TextSpan(text: "% on "),
              TextSpan(text: nameCurrency),
          ]
        ))
      ],
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
  final EdgeInsets symmetricPadding;

  const TradersSection({Key key, this.symmetricPadding}) : super(key: key);

  @override
  _TradersSectionState createState() => _TradersSectionState(symmetricPadding);
}

class _TradersSectionState extends State<TradersSection>{
  //DataExemple _data;
  List<double> _dataCurrency;
  List<String> _buttonsText = ["1H","12H","24H","2D","1W","1M","3M"];
  List<bool> _isActiveList = List.generate(7, (index) => index==2 ? true : false);
  DetailCurrencyChart chart;

  final EdgeInsets symmetricPadding;

  _TradersSectionState(this.symmetricPadding);

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
          padding: symmetricPadding,
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