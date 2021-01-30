import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
      new MaterialApp(debugShowCheckedModeBanner: false, home: Calculator()));
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String __operand1;
  String _operand2;
  bool _beforesign;
  String _delete = '';
  String _operator;
  String _calc;
  RegExp _signcheck = new RegExp(r'^-[0-9]*');
  RegExp _pointcheck = new RegExp(r'^[0-9]+$');
  double _fontsizeDefault = 40;
  double _fontsizeBig = 50;
  double _fontsizeSmall = 35;

  void newInput(char) {
    setState(() {
      if (_beforesign) {
        __operand1 += char;
        _calc = __operand1;
      } else {
        _operand2 += char;
        _calc = _operand2;
      }
    });
  }

  void point() {
    setState(() {
      if (_beforesign) {
        if (_pointcheck.hasMatch(__operand1)) {
          __operand1 += '.';
          _calc = __operand1;
        }
      } else {
        if (_pointcheck.hasMatch(_operand2)) {
          _operand2 += '.';
          _calc = _operand2;
        }
      }
    });
  }

  void operation(char) {
    setState(() {
      if (_beforesign) {
        _beforesign = false;
        _operator = char;
      } else {
        evaluate();
        _operator = char;
        _delete = 'C';
      }
    });
  }

  void minus() {
    setState(() {
      if (!_beforesign) {
        evaluate();
      }
      if (_signcheck.hasMatch(__operand1)) {
        __operand1 = __operand1.substring(1, __operand1.length);
        _calc = __operand1;
      } else {
        __operand1 = '-' + __operand1;
        _calc = __operand1;
      }
    });
  }

  void evaluate() {
    setState(() {
      switch (_operator) {
        case '/':
          __operand1 = '${double.parse(__operand1) / double.parse(_operand2)}';
          break;
        case '*':
          __operand1 = '${double.parse(__operand1) * double.parse(_operand2)}';
          break;
        case '-':
          __operand1 = '${double.parse(__operand1) - double.parse(_operand2)}';
          break;
        case '+':
          __operand1 = '${double.parse(__operand1) + double.parse(_operand2)}';
          break;
      }
      if (double.parse(__operand1) - double.parse(__operand1).floor() == 0) {
        __operand1 = '${double.parse(__operand1).toInt()}';
      }
      _operator = '';
      _calc = '$__operand1';
      _operand2 = '';
    });
  }

  void reset() {
    setState(() {
      if (_delete == 'AC') {
        _calc = '';
        __operand1 = '';
        _operand2 = '';
        _beforesign = true;
      } else if (_delete == 'C') _calc = '0';
      _operand2 = '';
      _delete = 'AC';
    });
  }

  void percentage() {
    setState(() {
      __operand1 = '${double.parse(__operand1) / 100}';
      if (double.parse(__operand1) - double.parse(__operand1).floor() == 0) {
        __operand1 = '${double.parse(__operand1).toInt()}';
      }
      _calc = __operand1;
    });
  }

  Widget _rowDefault(String str1, String str2, String str3, String str4) {
    return Expanded(
      child: Row(
        children: [
          _buttonInput(str1),
          _buttonInput(str2),
          _buttonInput(str3),
          _buttonOperator(str4)
        ],
      ),
    );
  }

  Widget _buttonInput(String str, {int width = 4}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / width,
      child: new RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          textColor: Colors.white,
          color: Colors.grey[850],
          onPressed: () {
            newInput(str);
          },
          child: new Text(str, style: TextStyle(fontSize: _fontsizeDefault))),
    );
  }

  Widget _buttonOperator(String str, {String ope}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 4,
      child: new RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          textColor: Colors.green,
          color: Colors.grey[400],
          onPressed: () {
            String opera;
            if (ope == null) {
              opera = str;
            } else {
              opera = ope;
            }
            operation(opera);
          },
          child: new Text(str, style: TextStyle(fontSize: _fontsizeBig))),
    );
  }

  Widget _buttonEvaluate() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width / 4,
      child: new RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: () {
            evaluate();
          },
          child: new Text('=', style: TextStyle(fontSize: _fontsizeBig))),
    );
  }

  @override
  void initState() {
    __operand1 = '';
    _operand2 = '';
    _delete = 'AC';
    _calc = '';
    _beforesign = true;
    super.initState();
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return new Scaffold(
        backgroundColor: Colors.black,
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: new Row(
                children: [
                  new Container(
                    child: new Text('$_calc',
                        style: TextStyle(
                            color: Colors.white, fontSize: _fontsizeDefault),
                        textDirection: TextDirection.ltr),
                  )
                ],
              ),
            ),
            Expanded(
              child: new Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  new SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width / 4,
                    child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        color: Colors.grey[400],
                        textColor: Colors.redAccent,
                        onPressed: () {
                          reset();
                        },
                        child: new Text(_delete,
                            style: TextStyle(fontSize: _fontsizeSmall))),
                  ),
                  new SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width / 4,
                    child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        color: Colors.grey[400],
                        onPressed: () {
                          minus();
                        },
                        child: new Text('+/-',
                            style: TextStyle(fontSize: _fontsizeSmall))),
                  ),
                  new SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width / 4,
                    child: new RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        color: Colors.grey[400],
                        onPressed: () {
                          percentage();
                        },
                        child: new Text('%',
                            style: TextStyle(fontSize: _fontsizeSmall))),
                  ),
                  _buttonOperator('\u{00F7}', ope: '/'),
                ],
              ),
            ),
            Expanded(
              child: new Row(
                children: [
                  _buttonInput('7'),
                  _buttonInput('8'),
                  _buttonInput('9'),
                  _buttonOperator('\u{00D7}', ope: '*')
                ],
              ),
            ),
            _rowDefault('4', '5', '6', '-'),
            _rowDefault('1', '2', '3', '+'),
            Expanded(
              child: new Row(
                children: [
                  _buttonInput('0', width: 2),
                  _buttonInput('.'),
                  _buttonEvaluate()
                ],
              ),
            )
          ],
        ));
  }
}
