import 'dart:ui';

import 'package:crypto_flutter_app/SizingTool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:crypto_flutter_app/logo.dart';

class SignInScreen extends StatefulWidget{

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final String singUpRouteName = "/sing_up";

  @override
  Widget build(BuildContext context) {

    Sizing.setSize(Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));

    Sizing sizing = Sizing().getInstence();

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Stack(children: [
          BackgroundLogoPaint(),
          Container(
            height: sizing.getDisplayHeight(),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: sizing.getValue(55)),
            child: Column(children: [
              LogoPaint(),
              Padding(
                  padding: EdgeInsets.only(top: 34),
                  child: SignInTitle()
              ),
              Padding(padding: EdgeInsets.only(top: 34), child: SignInForm())
            ]),
          ),
          Positioned(
            bottom: 0,
            child: BlackBottomArea(
              widthDisplay: sizing.getDisplayWidth(),
              linkText: "Sign Up",
              questionText: "Don't have an account?",
              onTapAction: (){
                Navigator.pushNamed(context, singUpRouteName);
              },
            ),
          )
        ]),
      ),
    );
  }
}

class SignInTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("""Sign In to
CryptoCamp""",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontFamily: "FredokaOne",
            fontSize: 26,
            fontWeight: FontWeight.w100,
        )
    );
  }

}

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();

}

class _SignInFormState extends State<SignInForm>{

  final _signInKey = GlobalKey<FormState>();

  FocusNode nameFocus;
  FocusNode passwordFocus;
  bool isValidateName = true;
  bool isValidatePassword = true;
  String nameLabel = "Your Name";
  String passwordLabel = "Your Password";
  bool isChecked = false;

  final String textLink = "Forgot Password?";
  final String passwordRecoveryScreenRoutName = "/password_recovery_screen";

  @override
  void initState(){
    super.initState();

    nameFocus = FocusNode();
    passwordFocus = FocusNode();
    nameFocus.addListener(() {
      setState(() {});
    });
    passwordFocus.addListener(() {
      setState(() {});
    });
    if(!isValidateName || !isValidatePassword){
      setState(() {});
    }
  }

  @override
  void dispose(){
    nameFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Sizing.setSize(Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height));
    double widthForm = Sizing().getInstence().getValue(175);

    return Form(
      key: _signInKey,
      child: Container(
        width: widthForm,
        child: Column(
          children: <Widget>[
            CustomField(
              validator: (value){
                if(value != "user"){
                  isValidateName = false;
                  setState(() {});
                  return "";
                } else {
                  isValidateName = true;
                  setState(() {});
                  return null;
                }
              },
              isValidate: isValidateName,
              fieldLabel: nameLabel,
              fieldFocus: nameFocus,
              obscureText: false,
            ),
            CustomField(
              validator: (value){
                if(value != "pass"){
                  isValidatePassword = false;
                  setState(() {});
                  return "";
                } else {
                  isValidatePassword = true;
                  setState(() {});
                  return null;
                }
              },
              isValidate: isValidatePassword,
              fieldLabel: passwordLabel,
              fieldFocus: passwordFocus,
              obscureText: true,
            ),
            Container(height: 10),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  StayCheckBox(
                    isStay: isChecked,
                    checkFn: (){
                      setState(() {
                        isChecked =!isChecked;
                      });
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 87),
                      child: LinkUnderFeilds(
                        textLink: textLink,
                        onTapAction: (){
                          Navigator.pushNamed(context, passwordRecoveryScreenRoutName);
                        },
                      )
                  )
                ],
              ),
            ),
            Container(height: 20),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: BigBlueButton(
                textButton: "Log In",
                forOnPressed: (){
                  if(_signInKey.currentState.validate()){
                    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing data"),));
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget{

  String Function(String value) validator;
  FocusNode fieldFocus;
  bool isValidate;
  String fieldLabel;
  bool obscureText;

  CustomField({
    this.validator,
    this.fieldFocus,
    this.isValidate,
    this.fieldLabel,
    this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      focusNode: fieldFocus,
      style: TextStyle(
        color: isValidate ? Colors.black : Colors.red,
      ),
      decoration: InputDecoration(
        labelText: fieldLabel,
        labelStyle: TextStyle(
          color: fieldFocus.hasFocus ? Color.fromRGBO(197, 197, 197, 1) : Colors.black,
          fontSize: fieldFocus.hasFocus ? 18 : 15,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          height: 0,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(237, 237, 237, 1),
                width: 2.5
            )
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromRGBO(173, 225, 238, 1),
                width: 2.5
            )
        ),
      ),
      validator: (value){
        return validator(value);
      },
      obscureText: obscureText,
    );
  }
}


class StayCheckBox extends StatelessWidget{

  bool isStay;
  Function checkFn;

  StayCheckBox({this.isStay, this.checkFn});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(children: [
      InkWell(
        onTap: checkFn,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isStay
                ? RadialGradient(colors: [
                    Color.fromRGBO(20, 20, 210, 1),
                    Color.fromRGBO(18, 63, 207, 1)
                  ])
                : RadialGradient(colors: [Colors.white, Colors.grey]),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
            "Stay sign in",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400
          ),
        ),
      )
    ]);
  }
}

class LinkUnderFeilds extends StatelessWidget{

  final String textLink;
  final Function onTapAction;

  LinkUnderFeilds({this.textLink, this.onTapAction});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RichText(
      text: TextSpan(
        text: textLink,
        style: TextStyle(color: Colors.cyan, fontSize: 15, fontWeight: FontWeight.w500),
        recognizer: TapGestureRecognizer()
          ..onTap = (){
            onTapAction();
          }
      ),
    );
  }

}

class BlackBottomArea extends StatelessWidget{

  final double widthDisplay;
  final Function onTapAction;
  final String questionText;
  final String linkText;


  const BlackBottomArea({Key key, this.widthDisplay, this.onTapAction, this.questionText, this.linkText}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widthDisplay,
      height: 110,
      color: Colors.black,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              questionText,
              style: TextStyle(
                  color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RichText(
              text: TextSpan(
                text: linkText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.cyan,
                  fontWeight: FontWeight.w400
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = (){
                    onTapAction();
                  },
              ),
            ),
          )
        ],
      ),
    );
  }

}

class BigBlueButton extends StatelessWidget{

  final String textButton;
  final Function forOnPressed;

  const BigBlueButton({Key key, this.textButton, this.forOnPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))
          )),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 15)),
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromRGBO(19, 89, 211, 1)),
          minimumSize: MaterialStateProperty.all<Size>(Size(306,0))
      ),
      onPressed: forOnPressed,
      child: Text(
        textButton,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

}