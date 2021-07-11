
import 'package:crypto_flutter_app/crypto_app_icons_icons.dart';
import 'package:crypto_flutter_app/logo.dart';
import 'package:crypto_flutter_app/screens/sign_in_screen.dart';
import 'package:crypto_flutter_app/screens/sing_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizingTool.dart';

class SelectCountryScreen extends StatefulWidget{
  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen>{

  bool isAccept = false;
  String acceptText = "Add your mobile phone to your account. Expland your "
      "experience, get closer, and stay current.";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Sizing.setSize(Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));

    Sizing sizing = Sizing().getInstence();

    double startPadding = sizing.getValue(55);
    double lrPadiing = Sizing().getInstence().getValue(27);

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Stack(
        children: [
          BackgroundLogoPaint(),
          Container(
            height: sizing.getDisplayHeight(),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.fromLTRB(lrPadiing, startPadding, lrPadiing, 0),
              child: Column(
                children: [
                  LogoPaint(),
                  Padding(
                      padding: EdgeInsets.only(top:30),
                      child: CryptoTitle()
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: DropCountry(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: AcceptCheckBox(
                      isAccept: isAccept,
                      checkFn: (){
                        setState(() {
                          isAccept =!isAccept;
                        });
                      },
                      acceptText: acceptText,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: BigBlueButton(
                      textButton: "Next",
                      forOnPressed: (){
                        Navigator.pushNamed(context, "/sign_in");
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}

class CryptoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: "CryptoCamp",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "FredokaOne",
              fontSize: 40,
              fontWeight: FontWeight.w100,
            ),
            children: [
              TextSpan(
                text: """ 
                
                
 """,
              ),
              TextSpan(
                  text: """Your Cryptocurrency
home base""",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "FredokaOne",
                    fontSize: 26,
                    fontWeight: FontWeight.w100,
                  )),
              TextSpan(
                text: ".",
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 24
                )
              )
            ]));
  }
}

class DropCountry extends StatefulWidget{
  @override
  _DropCountryState createState() => _DropCountryState();
}

class _DropCountryState extends State<DropCountry>{
  String dropdownValue = 'Select Your Country';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      child: DropdownButton<String>(
        icon: Icon(CryptoAppIcons.down_dir),
        iconSize: 20,
        elevation: 16,
        style: TextStyle(
            color: Colors.black
        ),
        underline: Container(
          height: 3,
          color: Color.fromRGBO(237, 237, 237, 1),
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Russian', 'Ukrainian', 'Belarus', 'Uzbekistan','Kazakhstan',
        'Georgia','Azerbaijan', 'Lithuania', 'Moldova', 'Latvia', 'Kyrgyzstan',
        'Tajikistan', 'Armenia', 'Turkmenistan', 'Estonia']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        })
            .toList(),
        isExpanded: true,
        isDense: true,
        hint: Text(
          dropdownValue,
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
    );
  }

}