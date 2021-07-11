
import 'package:crypto_flutter_app/logo.dart';
import 'package:crypto_flutter_app/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SizingTool.dart';

class SingUpScreen extends StatefulWidget{
  
  @override
  _SingUpScreenState createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen>{
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
      body: SingleChildScrollView(
        child: Stack(
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
                      child: SignUpTitle(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SingUpForm(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: BlackBottomArea(
                widthDisplay: sizing.getDisplayWidth(),
                questionText: "Already have an account?",
                linkText: "Sign In",
                onTapAction: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("""Join
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

class SingUpForm extends StatefulWidget{
  @override
  _SingUpFormState createState() => _SingUpFormState();
}

class _SingUpFormState extends State<SingUpForm>{

  final _singUpKey = GlobalKey<FormState>();

  FocusNode nameFocus;
  FocusNode emailFocus;
  FocusNode passwordFocus;
  bool isValidateName = true;
  bool isValidateEmail = true;
  bool isValidatePassword = true;
  String nameLabel = "Your name";
  String emailLabel = "Your email address";
  String passwordLabel = "Your password";
  bool isAccept = false;

  @override
  void initState(){
    super.initState();

    nameFocus = new FocusNode();
    emailFocus = new FocusNode();
    passwordFocus = new FocusNode();

    nameFocus.addListener(() {setState(() {});});
    emailFocus.addListener(() {setState(() {});});
    passwordFocus.addListener(() {setState(() {});});

    if(!isValidateName || !isValidateEmail || !isValidatePassword){
      setState(() {});
    }
  }

  @override
  void dispose(){
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _singUpKey,
      child: Column(
        children: <Widget>[
          CustomField(
            isValidate: isValidateName,
            fieldLabel: nameLabel,
            fieldFocus: nameFocus,
            obscureText: false,
          ),
          CustomField(
            isValidate: isValidateEmail,
            fieldLabel: emailLabel,
            fieldFocus: emailFocus,
            obscureText: false,
          ),
          CustomField(
            isValidate: isValidatePassword,
            fieldLabel: passwordLabel,
            fieldFocus: passwordFocus,
            obscureText: true,
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
              acceptText: "I have read and agreed to the terms of use and privacy police",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BigBlueButton(
              textButton: "Sing Up",
              forOnPressed: (){},
            ),
          ),
        ],
      ),
    );
  }

}

class AcceptCheckBox extends StatelessWidget {

  final bool isAccept;
  final Function checkFn;
  final String acceptText;

  const AcceptCheckBox({Key key, this.isAccept, this.checkFn, this.acceptText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 1),
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAccept
                      ? Color.fromRGBO(81, 80, 78, 1)
                      : Color.fromRGBO(81, 80, 78, 0)),
            ),
            InkWell(
              onTap: checkFn,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                      right: BorderSide(color: Colors.grey),
                      bottom: BorderSide(color: Colors.grey),
                      left: BorderSide(color: Colors.grey),
                    )),
              ),
            ),

          ]),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15),
          child: SizedBox(
            width: 268,
            child: Text(
              acceptText,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        )
      ],
    );
  }

}