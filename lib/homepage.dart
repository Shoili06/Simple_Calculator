import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class CalcLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainState = MainState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator", style: TextStyle(fontSize: 24.0),),
      ),
      body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: AssetImage("asset/wp.jpg"),
              fit: BoxFit.cover,
              color: Colors.grey,
              colorBlendMode: BlendMode.dstIn,
            ),
            Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: 180.0,
                      padding: EdgeInsets.all(15.0),
                      color: Colors.grey.withOpacity(0.30),
                      foregroundDecoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white)
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(mainState.inputValue ?? '0',
                            style: TextStyle(
                              color: Colors.white,
                              //fontWeight: FontWeight.w700,
                              fontSize: 40.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(height: 10.0),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          makeButtons("s*@%"),
                          makeButtons("789/"),
                          makeButtons("456X"),
                          makeButtons("123-"),
                          makeButtons(".0=+")
                        ],
                      ),
                    ),
                  )
                ]
            )
          ]
      ),
    );
  }


  Widget makeButtons(String row){
    List<String> token = row.split("");
    return Expanded(
        flex: 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
          token.map((e) =>
              CalcButton(
                keyValue : e == '@' ? "+/-" : e == '*' ? "AC" : e == 's'? "√" : e ,
              )
          ).toList(),
        )
    );
  }
}

class _HomePageState extends State<HomePage> {
  String inputString = "";
  double prevValue;
  String value="";
  String op='z';

  bool isNumber(String str){
    if (str == null){
      return false;
    }
    return double.parse(str, (e) => null) != null;
  }

  void onPressed(keyValue){
    switch(keyValue){
      case "AC":
        op= null;
        prevValue= 0.0;
        value="";
        setState(() => inputString ="");
        break;
      case ".":
      case "00":
      case "%":
      case "X":
      case "+":
      case "-":
      case "/":
        op = keyValue;
        value = '';
        prevValue = double.parse(inputString);
        setState(() {
          inputString = inputString + keyValue;
        });
        break;
      case "+/-":
        setState(() {
          inputString= (double.parse(inputString) * (-1)).toStringAsFixed(0);
          print(inputString);
        });
        break;
      case "√" :
        setState(() {
          inputString = pow(double.parse(inputString),0.5).toStringAsFixed(0);
          print(inputString);
        });
        break;
      case "=":
        if (op != null){
          setState(() {
            switch(op){
              case "+":
                inputString=
                    (prevValue + double.parse(value)).toStringAsFixed(2);
                break;
              case "-":
                inputString=
                    (prevValue - double.parse(value)).toStringAsFixed(0);
                break;
              case "X":
                inputString=
                    (prevValue * double.parse(value)).toStringAsFixed(0);
                break;
              case "/":
                inputString=
                    (prevValue / double.parse(value)).toStringAsFixed(2);
                break;
              case "%":
                inputString=
                    (prevValue % double.parse(value)).toStringAsFixed(0);
                break;
            }
          });
          op= null;
          prevValue= double.parse(inputString);
          value= '';
          break;
        }
        break;
      default :
        if (isNumber(keyValue)){
          if (op != null){
            setState(() => inputString = inputString + keyValue);
            value= value + keyValue;
          }else{
            setState(() => inputString = "" + keyValue);
            op = 'z';
          }
        }else{
          onPressed(keyValue);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainState(
      inputValue: inputString,
      prevValue: prevValue,
      value: value ,
      op: op,
      onPressed: onPressed,
      child: CalcLayout(),

    );
  }
}

class MainState extends InheritedWidget{
  MainState({
    Key key,
    this.inputValue,
    this.prevValue,
    this.value,
    this.op,
    this.onPressed,
    Widget child,
}) : super(key : key, child : child);

  final String inputValue;
  final double prevValue;
  final String value;
  final String op;
  final Function onPressed;

  @override
  bool updateShouldNotify(MainState oldwidget){
    return inputValue != oldwidget.inputValue;
  }

  static MainState of(BuildContext context){
    return context.inheritFromWidgetOfExactType(MainState);
  }
}



class CalcButton extends StatelessWidget {
  CalcButton({this.keyValue});
  final String keyValue;

  @override
  Widget build(BuildContext context) {
    final mainState= MainState.of(context);
    return Expanded(
      flex: 1,
        child: RaisedButton(
          shape: Border.all(
            color: Colors.red.withOpacity(0.5),
            width: 2.0,
            style: BorderStyle.solid
          ),
            color: Colors.grey.withOpacity(0.2),
            disabledTextColor: Colors.white,
            onPressed: (){
              mainState.onPressed(keyValue);
            },
            child: Text(keyValue,
              style: TextStyle(fontSize: 30.0),
            )
        )
    );
  }
}


