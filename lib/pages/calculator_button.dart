// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CalculatorButton extends StatefulWidget {
  const CalculatorButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.textColor,
      required this.bold,
      required this.color,
      required this.splashColor});

  final VoidCallback onTap;
  final String text;
  final FontWeight bold;
  final Color color;
  final Color textColor;
  final Color splashColor;

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: widget.color, // Button color
        child: InkWell(
          splashColor: widget.splashColor, // Splash color
          onTap: widget.onTap,
          child: SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Text(
                widget.text,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontWeight: widget.bold,
                    fontSize: 40,
                    color: widget.textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
