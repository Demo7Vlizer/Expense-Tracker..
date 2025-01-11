import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _currentNumber = "";
  String _expression = "";
  double _num1 = 0;
  String _operand = "";
  bool _newNumber = true;
  List<String> _history = [];
  String _notes = "";
  final String _notesKey = 'calculator_notes';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getString(_notesKey) ?? '';
    });
  }

  Future<void> _saveNotes(String notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, notes);
    setState(() {
      _notes = notes;
    });
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case "C":
          _clearAll();
          break;
        case "⌫":
          _backspace();
          break;
        case ".":
          _addDecimalPoint();
          break;
        case "%":
          _calculatePercentage();
          break;
        case "TAX+":
          _addTax(0.18); // 18% tax
          break;
        case "TAX-":
          _removeTax(0.18); // 18% tax
          break;
        case "+":
        case "-":
        case "×":
        case "÷":
          _setOperation(buttonText);
          break;
        case "=":
          _calculate();
          break;
        default:
          _addNumber(buttonText);
      }
    });
  }

  void _clearAll() {
    _output = "0";
    _currentNumber = "";
    _expression = "";
    _num1 = 0;
    _operand = "";
    _newNumber = true;
  }

  void _backspace() {
    if (_currentNumber.isNotEmpty) {
      _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
      if (_currentNumber.isEmpty) {
        _currentNumber = "0";
        _newNumber = true;
      }
      _updateOutput();
    }
  }

  void _addDecimalPoint() {
    if (_newNumber) {
      _currentNumber = "0.";
      _newNumber = false;
    } else if (!_currentNumber.contains(".")) {
      _currentNumber += ".";
    }
    _updateOutput();
  }

  void _calculatePercentage() {
    if (_currentNumber.isNotEmpty) {
      double number = double.parse(_currentNumber);
      if (_operand.isEmpty) {
        number = number / 100;
      } else {
        number = _num1 * (number / 100);
      }
      _currentNumber = number.toString();
      _updateOutput();
    }
  }

  void _addTax(double taxRate) {
    if (_currentNumber.isNotEmpty) {
      double number = double.parse(_currentNumber);
      _currentNumber = (number * (1 + taxRate)).toString();
      _updateOutput();
      _addToHistory(
          '${number.toString()} + ${(taxRate * 100).toStringAsFixed(0)}% tax = $_currentNumber');
    }
  }

  void _removeTax(double taxRate) {
    if (_currentNumber.isNotEmpty) {
      double number = double.parse(_currentNumber);
      _currentNumber = (number / (1 + taxRate)).toString();
      _updateOutput();
      _addToHistory(
          '${number.toString()} - ${(taxRate * 100).toStringAsFixed(0)}% tax = $_currentNumber');
    }
  }

  void _addToHistory(String calculation) {
    setState(() {
      _history.insert(0, calculation);
      if (_history.length > 10) {
        _history.removeLast();
      }
    });
  }

  void _setOperation(String op) {
    if (_currentNumber.isNotEmpty) {
      _num1 = double.parse(_currentNumber);
      _operand = op;
      _expression = _currentNumber + " " + op;
      _newNumber = true;
    }
  }

  void _addNumber(String number) {
    if (_newNumber) {
      _currentNumber = number;
      _newNumber = false;
    } else {
      _currentNumber += number;
    }
    _updateOutput();
  }

  void _updateOutput() {
    if (_expression.isEmpty) {
      _output = _currentNumber;
    } else {
      _output = _expression + " " + _currentNumber;
    }
  }

  void _calculate() {
    if (_currentNumber.isEmpty || _operand.isEmpty) return;

    double num2 = double.parse(_currentNumber);
    double result = 0;

    switch (_operand) {
      case "+":
        result = _num1 + num2;
        break;
      case "-":
        result = _num1 - num2;
        break;
      case "×":
        result = _num1 * num2;
        break;
      case "÷":
        if (num2 != 0) {
          result = _num1 / num2;
        } else {
          _output = "Error";
          _currentNumber = "";
          _expression = "";
          _num1 = 0;
          _operand = "";
          _newNumber = true;
          return;
        }
        break;
    }

    String calculation = "$_num1 $_operand $num2 = ${result.toString()}";
    _addToHistory(calculation);

    _expression = "";
    _output = result.toString();
    if (_output.endsWith(".0")) {
      _output = _output.substring(0, _output.length - 2);
    }
    _currentNumber = _output;
    _operand = "";
  }
//-----------------------------------------------------------------------------------------------
//--- NOTES SECTION ----------------------------------------------------------------------------

  void _showNotesDialog() {
    final TextEditingController notesController =
        TextEditingController(text: _notes);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.note_alt_outlined, color: Color(0xFF6B4EFF)),
            SizedBox(width: 8),
            Text(
              'Notes',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your notes here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF6B4EFF), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                onChanged: (value) {
                  _saveNotes(value);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveNotes('');
              notesController.clear();
            },
            child: Text(
              'Clear',
              style: TextStyle(
                color: Colors.red[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF6B4EFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText,
      {Color? backgroundColor, Color? textColor}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: Material(
          color: backgroundColor ?? Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _buttonPressed(buttonText),
            child: Container(
              height: 65,
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Financial Calculator',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.note_alt_outlined),
                if (_notes.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Color(0xFF6B4EFF),
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showNotesDialog,
            tooltip: 'Notes',
          ),
        ],
      ),
      body: Column(
        children: [
          // Display
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 100),
                Text(
                  _output,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Tax functions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            child: Row(
              children: [
                _buildButton("%", backgroundColor: Colors.grey[200]),
                _buildButton("⌫", backgroundColor: Colors.grey[200]),
                _buildButton("TAX+",
                    backgroundColor: Color(0xFF6B4EFF),
                    textColor: Colors.white),
                _buildButton("TAX-",
                    backgroundColor: Color(0xFF6B4EFF),
                    textColor: Colors.white),
              ],
            ),
          ),
          // Number pad and operations
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 40.0, top: 20, left: 10, right: 10),
              child: Container(
                // padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("7"),
                          _buildButton("8"),
                          _buildButton("9"),
                          _buildButton("÷",
                              backgroundColor: Color(0xFF6B4EFF),
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("4"),
                          _buildButton("5"),
                          _buildButton("6"),
                          _buildButton("×",
                              backgroundColor: Color(0xFF6B4EFF),
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("1"),
                          _buildButton("2"),
                          _buildButton("3"),
                          _buildButton("-",
                              backgroundColor: Color(0xFF6B4EFF),
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton("C",
                              backgroundColor: Color(0xFFFF5252),
                              textColor: Colors.white),
                          _buildButton("0"),
                          _buildButton(".", backgroundColor: Colors.grey[200]),
                          _buildButton("+",
                              backgroundColor: Color(0xFF6B4EFF),
                              textColor: Colors.white),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 4,
                        ),
                        child: ElevatedButton(
                          onPressed: () => _buttonPressed("="),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6B4EFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Center(
                            child: Text(
                              "=",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
