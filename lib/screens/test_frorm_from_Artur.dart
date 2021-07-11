import 'package:crypto_flutter_app/screens/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestFormFromArtur extends StatefulWidget{

  @override
  _TestFormFromArturState createState() => _TestFormFromArturState();
}

class _TestFormFromArturState extends State<TestFormFromArtur>{
  double displayWidth;
  
  final _signInKey = GlobalKey<FormState>();

  Widget line = Divider(
      height: 2,
      color: Color.fromRGBO(246,247,251,1)
  );
  
  @override
  Widget build(BuildContext context) {
    displayWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: displayWidth - 50,
            color: Color.fromRGBO(246,247,251,1),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                width: displayWidth - 50 - 20,
                child: Form(
                  key: _signInKey,
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      line,
                      SizedBox(height: 22),
                      Text(
                          "E-mail",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26
                        ),
                      ),
                      SizedBox(height: 26),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),

                        ),
                        width: displayWidth - 50 - 20 -20,
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'user@gmail.com',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18
                              ),

                          ),
                        ),
                      ),
                      SizedBox(height: 28),
                      line,
                      Text(
                        "Кулинарное обраование",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28
                        ),
                      ),
                      SizedBox(height: 26),
                      Container(
                        width: displayWidth - 50 - 20 - 54,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(242, 155, 22, 1),
                                    Color.fromRGBO(242, 87, 4, 1),
                                  ]
                                )
                              ),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)))),
                                  ),
                                  onPressed: null,
                                  child: Text("")),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonForm extends StatelessWidget{
  final bool isPressed;

  const ButtonForm({Key key, this.isPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 4,
          ),
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
              colors: [
                isPressed ? Color.fromRGBO(242, 155, 22, 1) : Colors.white.withOpacity(0),
                isPressed ? Color.fromRGBO(242, 87, 4, 1) : Colors.white.withOpacity(0),
              ]
          )
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<
                OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0)))),
          ),
          onPressed: null,
          child: Text("")),
    );
  }


}