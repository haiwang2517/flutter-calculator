
import 'dart:ffi';

import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  static const ac = "AC";
  static const rebellion = "+/-";
  static const percent = "%";

  static const one = "1";
  static const two = "2";
  static const three = "3";
  static const four = "4";
  static const five = "5";
  static const six = "6";
  static const sven = "7";
  static const eight = "8";
  static const nine = "9";
  static const zero = "0";

  static const addition = "+";
  static const subtraction = "-";
  static const multiplication = "x";
  static const division = "÷";
  static const calculate = "=";
  static const point = ".";

  static const buttonKey = [
    ac, rebellion, percent, division,
    sven, eight, nine, multiplication,
    four, five, six, subtraction,
    one, two, three, addition,
    zero, "", point, calculate
  ];

  const Calculator({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalculatorState();
  }
}
class CalculatorState extends State<Calculator>{
  String result = "";
  String formula = "";
  String operate = "";
  double number = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("计算器"),
          centerTitle: true
        ),
      body: Column(
        children: <Widget>[
           Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(children: [
                      Expanded(
                          child: Container(
                            color: Colors.black,
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.only(right: 10),
                            child:  Text(formula, style: const TextStyle(fontSize: 30.0, color: Colors.white)),
                        ),
                      )
                    ])
                  ),
                  Expanded(
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          color: Colors.black,
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.only(right: 10),
                          child:  Text(result, style: const TextStyle(fontSize: 50.0, color: Colors.white)),
                        ),
                      )
                    ])
                  )
                ],
              )
          ),
          Center(child: Expanded(
            child: Container(
              color: Colors.black,
              child: buildColumnButton(),
            )
          ))
        ],
      )
    );
  }

  Column buildColumnButton(){
    // 循环创建按钮， 4个一行
    List<Widget> rows = [];
    List<Widget> column = [];
    int keyLength = Calculator.buttonKey.length;
    int i = 0;
    for(; i < keyLength; i++){
      if (Calculator.buttonKey[i].trim().isEmpty){
        continue;
      }
      bool isEnd = ((i + 1) % 4 == 0);
      column.add(creteButton(Calculator.buttonKey[i], isEnd));
      if (isEnd){
        rows.add(Row(
          children: column,
        ));
        column = [];
      }
    }

    return Column(children: rows);
  }

  void clickButton (String value){
    print("clickButton " + value + " operate " + operate);
    String _result = result;
    String _formula = formula;
    switch(value){
      case Calculator.zero:
      case Calculator.one:
      case Calculator.two:
      case Calculator.three:
      case Calculator.four:
      case Calculator.five:
      case Calculator.six:
      case Calculator.sven:
      case Calculator.eight:
      case Calculator.nine:
        if (_result.length == 1 && _result.startsWith(Calculator.zero)){
          _result = value;
          break;
        }
        _result += value;
        _formula = getFormula(operate, _result);
        break;
      case Calculator.point:
        if(_result.contains(Calculator.point)){
          break;
        }
        _result += value;
        break;

      // 操作函数
      case Calculator.ac:
        _result = "0";
        operate = "";
        number = 0.0;
        _formula = "";
        break;
      case Calculator.rebellion:
        if (_result.length == 1 && _result.startsWith(Calculator.zero)){
          break;
        }

        if(_result.startsWith("-")){
          _result = _result.substring(1);
          break;
        }
        _result = "-" + _result;
        break;

      case Calculator.percent:
        double number = getDouble(_result);
        double percentResult = number / 100.0;
        _result = percentResult.toString();
        break;

      // 操作
      case Calculator.addition:
      case Calculator.subtraction:
      case Calculator.multiplication:
      case Calculator.division:

        if(operate.isEmpty){
          number = getDouble(_result);
          _result = "0";
          _formula = getFormula(value, _result);
        } else {
          _formula = getFormula(operate, _result);
          _result = getCalculator(operate, _result);
          number = getDouble(_result);
        }
        operate = value;
        break;

      // 计算结果
      case Calculator.calculate:
        if (operate.isEmpty){
          break;
        }
        _formula = getFormula(operate, _result);
        _result = getCalculator(operate, _result);
        number = getDouble(_result);
        operate = "";
        break;
    }

    setState(() {
      result = _result;
      formula = _formula;
    });
  }

  String getFormula(String operate , String _result) {
    if (operate.isEmpty){
      return "";
    }
    return number.toString() + " " + operate + " " + _result + " ";
  }

  String getCalculator(String operate, String numberStr) {
    switch(operate){
      case Calculator.addition:
        number = number + getDouble(numberStr);
        return number.toString();
      case Calculator.subtraction:
        number = number - getDouble(numberStr);
        return number.toString();
      case Calculator.multiplication:
        number = number * getDouble(numberStr);
        return number.toString();
      case Calculator.division:
        number = number / getDouble(numberStr);
        return number.toString();
    }
    return numberStr;
  }

  double getDouble(String value){
    return double.parse(value);
  }

  Widget creteButton(String value, bool isEnd){

    return Expanded(
        flex: value == "0" ? 2 : 1,
        child: TextButton(
          onPressed: (){
            clickButton(value);
          },
          child: Container(
            decoration: BoxDecoration(
                color: isEnd ? Colors.orange : Colors.white30,
                shape: value == "0" ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: value == "0" ? const BorderRadius.all(Radius.circular(200)): null
            ),

            child: InkWell(
                child: Container(
                  width: value == "0" ? 160 : 70,
                  height: 70,
                  alignment: Alignment.center,
                  child: Text(value,
                    style: const TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                )
            ) ,
          )
        )
    );
  }



}
