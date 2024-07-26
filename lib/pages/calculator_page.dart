// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'calculator_button.dart';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  String inputText = '';
  String outputText = '';
  final digit = RegExp(r'\d');
  final operators = RegExp(r'[+×÷%]');

  //Calculate input into a number when = is pressed
  String equals(String input) {
    if (!brackets(input)) {
      return 'Error: Brackets';
    }

    input = operationReplace(input);

    Parser p = Parser();
    Expression exp = p.parse(input);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    String result = eval.toString();

    if (result.endsWith('.0')) {
      return result.substring(0, result.length - 2);
    }

    return result;
  }

  //Multiplication, Division, Subraction Fix
  String operationReplace(String input) {
    input = input.replaceAll(RegExp(r'÷'), '/');
    input = input.replaceAll(RegExp(r'×'), '*');
    input = input.replaceAll(RegExp(r'−'), '-');

    return input;
  }

  //Brackets Checker
  bool brackets(String input) {
    String brackets = '';
    List<String> openB = [];

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '(' || input[i] == ')') {
        brackets += input[i];
      }
    }

    if (brackets.length.isOdd) {
      return false;
    }

    for (int i = 0; i < brackets.length; i++) {
      String char = brackets[i];

      if (char == '(') {
        openB.add(char);
        continue;
      }

      switch (openB.last) {
        case '(':
          if (char == ')') {
            openB.removeLast();
          } else {
            return false;
          }
      }
    }

    return openB.isEmpty;
  }

  //Bracket Button
  String bracketBtn(String input) {
    int openB = 0;
    int closeB = 0;

    for (int i = 0; i < input.length; i++) {
      if (input[i] == '(') {
        openB++;
      }
      if (input[i] == ')') {
        closeB++;
      }
    }

    if (input.isNotEmpty) {
      if (input.length > 1 &&
          input[input.length - 2] == ')' &&
          !digit.hasMatch(input[input.length - 1]) &&
          !input.endsWith(')')) {
        return '(';
      } else if (openB == 0 && !digit.hasMatch(input[input.length - 1])) {
        return '(';
      } else if (closeB == openB) {
        return '×(';
      } else if (input.endsWith('(')) {
        return '(';
      } else if (closeB < openB &&
          !operators.hasMatch(input[input.length - 1])) {
        return ')';
      } else {
        return '(';
      }
    } else {
      return '(';
    }
  }

  //Decimal Fix
  String decimal(String input) {
    int lastIndex = input.lastIndexOf(RegExp('[+−×÷%()]'));

    if (input.isNotEmpty &&
        input.contains('.', lastIndex > 0 ? lastIndex : 0)) {
      return '';
    } else if (input.isEmpty || !digit.hasMatch(input[input.length - 1])) {
      return "0.";
    } else {
      return ".";
    }
  }

  void operatorsButtons(String calcBtn) {
    setState(() {
      if (inputText.isEmpty ||
          !inputText.endsWith(')') &&
              !digit.hasMatch(inputText[inputText.length - 1])) {
      } else {
        inputText += calcBtn;
      }
    });
  }

  void numberButtons(String calcBtn) {
    setState(() {
      if (inputText.endsWith(')')) {
        inputText += '×$calcBtn';
      } else {
        inputText += calcBtn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 47, 47, 47),
      body: Column(
        children: [
          Container(
            height: 40,
            color: Colors.black,
          ),

          //input
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              //padding: EdgeInsets.only(left: 15, right: 15),
              //height: 200,
              color: Color.fromARGB(255, 0, 0, 0),
              child: SelectableText(
                inputText,
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 255, 221, 190),
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),

          //result
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 90,
            color: const Color.fromARGB(255, 27, 27, 27),
            child: SelectableText(
              outputText,
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 255, 221, 190),
              ),
              textAlign: TextAlign.right,
            ),
          ),

          //delete
          Container(
            height: 60,
            padding: EdgeInsets.only(right: 15),
            color: Color.fromARGB(255, 35, 35, 35),
            alignment: Alignment.centerRight,
            child: ClipOval(
              child: Material(
                color: Color.fromARGB(255, 35, 35, 35),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (inputText.isNotEmpty) {
                        inputText =
                            inputText.substring(0, inputText.length - 1);
                        outputText = '';
                      }
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      inputText = '';
                      outputText = '';
                    });
                  },
                  splashColor: const Color.fromARGB(36, 244, 67, 54),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.backspace_outlined,
                      color: Color.fromARGB(255, 250, 93, 21),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),

          //calculator buttons
          Container(
            height: 15,
          ),

          //Row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //C
              CalculatorButton(
                onTap: () {
                  setState(() {
                    inputText = '';
                    outputText = '';
                  });
                },
                text: 'C',
                textColor: Color.fromARGB(255, 149, 15, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: const Color.fromARGB(186, 244, 67, 54),
              ),

              //()
              CalculatorButton(
                onTap: () {
                  setState(() {
                    if (!inputText.endsWith('.')) {
                      inputText += bracketBtn(inputText);
                    }
                  });
                },
                text: '()',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),

              //%
              CalculatorButton(
                onTap: () {
                  operatorsButtons('%');
                },
                text: '%',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),

              //÷
              CalculatorButton(
                onTap: () {
                  operatorsButtons('÷');
                },
                text: '÷',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),
            ],
          ),

          Container(
            height: 10,
          ),

          //Row2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //7
              CalculatorButton(
                onTap: () {
                  numberButtons('7');
                },
                text: '7',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //8
              CalculatorButton(
                onTap: () {
                  numberButtons('8');
                },
                text: '8',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //9
              CalculatorButton(
                onTap: () {
                  numberButtons('9');
                },
                text: '9',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //×
              CalculatorButton(
                onTap: () {
                  operatorsButtons('×');
                },
                text: '×',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),
            ],
          ),

          Container(
            height: 10,
          ),

          //Row 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //4
              CalculatorButton(
                onTap: () {
                  numberButtons('4');
                },
                text: '4',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //5
              CalculatorButton(
                onTap: () {
                  numberButtons('5');
                },
                text: '5',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //6
              CalculatorButton(
                onTap: () {
                  numberButtons('6');
                },
                text: '6',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //−
              CalculatorButton(
                onTap: () {
                  setState(() {
                    if (inputText.endsWith('−')) {
                      inputText += '(−';
                    } else if (inputText.endsWith('.')) {
                    } else {
                      inputText += '−';
                    }
                  });
                },
                text: '−',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),
            ],
          ),

          Container(
            height: 10,
          ),

          //Row4
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //1
              CalculatorButton(
                onTap: () {
                  numberButtons('1');
                },
                text: '1',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //2
              CalculatorButton(
                onTap: () {
                  numberButtons('2');
                },
                text: '2',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //3
              CalculatorButton(
                onTap: () {
                  numberButtons('3');
                },
                text: '3',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //+
              CalculatorButton(
                onTap: () {
                  operatorsButtons('+');
                },
                text: '+',
                textColor: Color.fromARGB(255, 0, 128, 6),
                bold: FontWeight.w900,
                color: Colors.white,
                splashColor: Colors.lightGreen,
              ),
            ],
          ),

          Container(
            height: 10,
          ),

          //Row5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //اذكر الله
              ClipOval(
                child: Material(
                  color: Colors.black, // Button color
                  child: InkWell(
                    splashColor: Colors.white, // Splash color
                    onTap: () {},
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Text(
                          'اذْكُرُ اللَّهَ',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //0
              CalculatorButton(
                onTap: () {
                  numberButtons('0');
                },
                text: '0',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //.
              CalculatorButton(
                onTap: () {
                  setState(() {
                    if (inputText.endsWith(')')) {
                      inputText += '×${decimal(inputText)}';
                    } else {
                      inputText += decimal(inputText);
                    }
                  });
                },
                text: '.',
                textColor: Colors.black,
                bold: FontWeight.w400,
                color: Colors.white,
                splashColor: Colors.grey,
              ),

              //=
              CalculatorButton(
                onTap: () {
                  setState(() {
                    if (inputText.isNotEmpty) outputText = equals(inputText);
                  });
                },
                text: '=',
                textColor: Colors.white,
                bold: FontWeight.w900,
                color: Color.fromARGB(255, 12, 74, 12),
                splashColor: Colors.lightGreen,
              ),
            ],
          ),

          Container(
            height: 15,
          ),
        ],
      ),
    );
  }
}
