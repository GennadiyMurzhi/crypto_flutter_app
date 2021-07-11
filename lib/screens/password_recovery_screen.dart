
import 'package:crypto_flutter_app/crypto_app_icons_icons.dart';
import 'package:crypto_flutter_app/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizingTool.dart';

class PasswordRecoveryScreen extends StatefulWidget{
  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double startPadding = 110;
    double lrPadiing = Sizing().getInstence().getValue(27); // left and right padding

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(lrPadiing, startPadding, lrPadiing, 0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                PasswordLogo(),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: PasswordRecoveryTitle(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: PasswordRecoveryForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class PasswordLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 4,
      height: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(19, 89, 211, 1)
      ),
      child: Icon(
        CryptoAppIcons.forgot_key,
        size: 42,
        color: Colors.white,
      ),
    );
  }

}

class PasswordRecoveryTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("Password Recovery",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontFamily: "FredokaOne",
          fontSize: 24,
          fontWeight: FontWeight.w100,
          wordSpacing: 1,
          letterSpacing: 0.01,
        ));
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  @override
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State <PasswordRecoveryForm>{

  final _PasswordRecoveryFormKey = GlobalKey<FormState>();

  String proposalToIntroduceEmail = "Enter your email address bellow and we'll send a special a reset password link to your inbox";
  FocusNode emailFocus;
  bool isValidateEmail = true;
  String emailLabel = "Your email address";

  final String textLink = "Resend recovery instruction";

  @override
  void initState(){
    super.initState();

    emailFocus = FocusNode();
    emailFocus.addListener(() {
      setState(() {});
    });

    if(!isValidateEmail){
      setState(() {});
    }
  }
  @override
  void dispose(){
    emailFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _PasswordRecoveryFormKey,
      child: Column(
        children: <Widget> [
          Text(
            proposalToIntroduceEmail,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: CustomField(
                validator: (value){
                if(value != "crypto@gmail.com"){
                  isValidateEmail = false;
                  setState(() {});
                  return "";
                } else {
                  isValidateEmail = true;
                  setState(() {});
                  return "";
                }
              },
              fieldFocus: emailFocus,
              isValidate: isValidateEmail,
              fieldLabel: emailLabel,
              obscureText: false,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: LinkUnderFeilds(
                textLink: textLink,
                onTapAction: (){},
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: BigBlueButton(
              textButton: "Send recovery email",
              forOnPressed: (){},
            ),
          )
        ],
      ),
    );
  }

}

