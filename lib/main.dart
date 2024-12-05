import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0"; // Store the current input/output

  Widget calButton(String text, Color btncolor, Color textColor) {
    return SizedBox(
      height: 70.0,
      width: 70.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btncolor,
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
        ),
        onPressed: () {
          setState(() {
            if (text == 'AC') {
              clear();
            } else if (text == '=') {
              evaluate();
            } else if (text == '⌫') {
              undo();
            } else {
              // Handle operators and numbers
              if (output == "0" && text != ".") {
                output = text; // Replace initial "0" except for decimals
              } else {
                if (_isOperator(text) &&
                    _isOperator(output[output.length - 1])) {
                  // Prevent adding consecutive operators
                  output = output.substring(0, output.length - 1) + text;
                } else if (text == "+/-") {
                  output = output;
                } else {
                  output += text;
                }
              }
            }
          });
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30.0,
            color: textColor,
          ),
        ),
      ),
    );
  }

// Function to check if a character is an operator
  bool _isOperator(String c) {
    return c == '+' || c == '-' || c == 'x' || c == '/';
  }

  // Function to clear the display
  void clear() {
    setState(() {
      output = "0";
    });
  }

//Function to remove the last character
  void undo() {
    setState(() {
      if (output.length > 1) {
        output =
            output.substring(0, output.length - 1); // Remove last character
      } else {
        output = "0"; // Reset to 0 if only one character remains
      }
    });
  }

  // Function to evaluate the expression (simple implementation)
  void evaluate() {
    try {
      String finalOutput = output.replaceAll('x', '*');
      Parser parser = Parser();
      Expression expression = parser.parse(finalOutput);
      ContextModel contextModel = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        output = result.toStringAsFixed(2).replaceAll(RegExp(r'\.0*$'), '');
      });
    } catch (e) {
      setState(() {
        output = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Calculator'),
      //   backgroundColor: Colors.black,
      //   foregroundColor: Colors.white,
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Adjust height
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AppBar(
            title: const Text('Calculator'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0, // Remove shadow if needed
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display area for current input/output
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    output,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 80.0),
                  ),
                ),
              ],
            ),
            // First row with AC, +/-, %, /
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calButton('AC', Colors.grey, Colors.black),
                calButton('⌫', Colors.grey, Colors.black),
                calButton('+/-', Colors.grey, Colors.black),
                calButton('/', Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(height: 20.0),
            // Second row with number buttons 7, 8, 9, x
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calButton('7', Colors.grey.shade900, Colors.white),
                calButton('8', Colors.grey.shade900, Colors.white),
                calButton('9', Colors.grey.shade900, Colors.white),
                calButton('x', Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(height: 20.0),
            // Third row with number buttons 4, 5, 6, -
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calButton('4', Colors.grey.shade900, Colors.white),
                calButton('5', Colors.grey.shade900, Colors.white),
                calButton('6', Colors.grey.shade900, Colors.white),
                calButton('-', Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(height: 20.0),
            // Fourth row with number buttons 1, 2, 3, +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calButton('1', Colors.grey.shade900, Colors.white),
                calButton('2', Colors.grey.shade900, Colors.white),
                calButton('3', Colors.grey.shade900, Colors.white),
                calButton('+', Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(height: 20.0),
            // Fifth row with 0 button (spanning two columns), . and =
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     setState(() {
                //       if (output == "0") {
                //         output = "0";
                //       } else {
                //         output += "0"; // Append 0
                //       }
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     shape: const CircleBorder(),
                //     backgroundColor: Colors.grey.shade900,
                //     padding: const EdgeInsets.all(20.0),
                //   ),
                //   child: const Text(
                //     '0',
                //     style: TextStyle(fontSize: 35, color: Colors.white),
                //   ),
                // ),
                calButton('%', Colors.grey.shade900, Colors.white),
                calButton('0', Colors.grey.shade900, Colors.white),
                calButton('.', Colors.grey.shade900, Colors.white),
                calButton('=', Colors.amber.shade700, Colors.white),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
