// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class CalcPage extends StatefulWidget {
  const CalcPage({super.key});

  @override
  State<CalcPage> createState() => _CalcPageState();
}

class _CalcPageState extends State<CalcPage> {
  String inputText = '';
  String outputText = '';
  final digit = RegExp(r'\d');
  final operations = RegExp(r'[+|×|÷|%]');
  List<int> indeces = [0, 0, 0, 0];
  int largestIndex = 0;

  //Long Press Back
  void backBtnLong() {
    setState(() {
      inputText = '';
      outputText = '';
    });
  }

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

      String lastB = openB.last;

      switch (lastB) {
        case '(':
          if (char == ')') {
            openB.removeLast();
          } else {
            return false;
          }
      }
    }

    return (openB.isEmpty);
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
          !operations.hasMatch(input[input.length - 1])) {
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
    largestIndex = findLargestIndex(input);

    if (input.isNotEmpty && input.contains('.', largestIndex)) {
      return '';
    } else if (input.isEmpty || !digit.hasMatch(input[input.length - 1])) {
      return "0.";
    } else {
      return ".";
    }
  }

  //Largest Index
  int findLargestIndex(String input) {
    indeces[0] = input.lastIndexOf(RegExp('[+]'));
    indeces[1] = input.lastIndexOf(RegExp('[-]'));
    indeces[2] = input.lastIndexOf(RegExp('[×]'));
    indeces[3] = input.lastIndexOf(RegExp('[÷]'));
    return indeces.reduce(max) == -1 ? 0 : indeces.reduce(max);
  }

  void calculate(String calcBtn) {
    setState(() {
      switch (calcBtn) {
        case 'C':
          inputText = '';
          outputText = '';
        case '⌫':
          if (inputText.isNotEmpty) {
            inputText = inputText.substring(0, inputText.length - 1);
            outputText = '';
          }
        case '.':
          if (inputText.endsWith(')')) {
            inputText += '×${decimal(inputText)}';
          } else {
            inputText += decimal(inputText);
          }
        case '=':
          if (inputText.isNotEmpty) outputText = equals(inputText);
        case '()':
          if (inputText.endsWith('.')) {
          } else {
            inputText += bracketBtn(inputText);
          }
        case '−':
          if (inputText.endsWith('−')) {
            inputText += '($calcBtn';
          } else if (inputText.endsWith('.')) {
          } else {
            inputText += calcBtn;
          }
        case '+':
        case '×':
        case '÷':
        case '%':
          if (inputText.isEmpty ||
              !inputText.endsWith(')') &&
                  !digit.hasMatch(inputText[inputText.length - 1])) {
          } else {
            inputText += calcBtn;
          }
        default:
          if (inputText.endsWith(')')) {
            inputText += '×$calcBtn';
          } else {
            inputText += calcBtn;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //input
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            height: 200,
            color: Colors.black,
            child: SelectableText(
              inputText,
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 255, 221, 190),
              ),
              textAlign: TextAlign.right,
            ),
          ),

          //result
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 100,
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
            height: 70,
            padding: EdgeInsets.only(right: 15),
            color: Color.fromARGB(255, 35, 35, 35),
            alignment: Alignment.centerRight,
            child: ClipOval(
              child: Material(
                color: Color.fromARGB(255, 35, 35, 35),
                child: InkWell(
                  onTap: () {
                    calculate('⌫');
                  },
                  onLongPress: backBtnLong,
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

          //delete
          //  Container(
          //     height: 70,
          //     padding: EdgeInsets.only(right: 15),
          //     color: Color.fromARGB(255, 35, 35, 35),
          //     alignment: Alignment.centerRight,
          //    child: IconButton(
          //      icon: Icon(Icons.backspace_outlined),
          //      onPressed: () {
          //        calculate('⌫');
          //       },
          //      color: Color.fromARGB(255, 250, 93, 21),
          //      iconSize: 30,
          //      ),
          //    ),

          //calculator buttons
          Expanded(
              child: Container(
            padding: EdgeInsets.only(top: 25, bottom: 15),
            color: Color.fromARGB(255, 47, 47, 47),
            child: Row(
              children: [
                //Row 1
                Expanded(
                    child: Column(
                  children: [
                    //Column - C
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () {
                                calculate('C');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "C",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: const Color.fromARGB(
                                            255, 149, 15, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 7
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('7');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "7",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 4
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('4');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "4",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 1
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('1');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "1",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - ±
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color:
                                Color.fromARGB(255, 26, 26, 26), // Button color
                            child: InkWell(
                              splashColor: Color.fromARGB(
                                  255, 255, 255, 255), // Splash color
                              onTap: () {},
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "اذْكُرُ اللَّهَ",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Color.fromARGB(255, 26, 26, 26),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

                //Row 2
                Expanded(
                    child: Column(
                  children: [
                    //Column - ()
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('()');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "()",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 8
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('8');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "8",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 5
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('5');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "5",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 2
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('2');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "2",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 0
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('0');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "0",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

                //Row 3
                Expanded(
                    child: Column(
                  children: [
                    //Column - %
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('%');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "%",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 9
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('9');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "9",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 6
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('6');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "6",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - 3
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('3');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "3",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - .
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.grey, // Splash color
                              onTap: () {
                                calculate('.');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    ".",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),

                //Row 4
                Expanded(
                    child: Column(
                  children: [
                    //Column - ÷
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('÷');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "÷",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - ×
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('×');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "×",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - -
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('−');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "−",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - +
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color: Colors.white, // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('+');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "+",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Color.fromARGB(255, 0, 128, 6)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Column - =
                    Expanded(
                      child: Center(
                        child: ClipOval(
                          child: Material(
                            color:
                                Color.fromARGB(255, 12, 74, 12), // Button color
                            child: InkWell(
                              splashColor: Colors.lightGreen, // Splash color
                              onTap: () {
                                calculate('=');
                              },
                              child: SizedBox(
                                width: 65,
                                height: 65,
                                child: Center(
                                  child: Text(
                                    "=",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 40,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
