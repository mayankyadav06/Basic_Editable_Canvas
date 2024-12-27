import 'package:editable_canvas/models/textstate_model.dart';
import 'package:flutter/material.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  TextState? _currentTextState;

  final List<TextState> _undoStack = [];
  final List<TextState> _redoStack = [];

  final List<String> _fontStyles = ['Roboto', 'Lobster', 'Pacifico'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        leadingWidth: 225,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              child: IconButton(
                icon: Icon(
                  Icons.text_format_sharp,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    // Add text centered on the screen
                    _currentTextState = TextState(
                        position: Offset(
                          screenSize.width / 2 - 30,
                          screenSize.height / 2 - 80,
                        ),
                        isBold: false,
                        isItalic: false,
                        fontFamily: 'Roboto');
                    ;

                    _undoStack.clear();
                    _redoStack.clear();

                    _undoStack.add(_currentTextState!);
                  });
                },
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon: Icon(Icons.format_bold,
                    color: _currentTextState?.isBold == true
                        ? Colors.blue
                        : Colors.white),
                onPressed: () {
                  setState(() {
                    if (_currentTextState != null) {
                      _currentTextState = TextState(
                        position: _currentTextState!.position,
                        isBold: !_currentTextState!.isBold,
                        isItalic: _currentTextState!.isItalic,
                        fontFamily: _currentTextState!.fontFamily,
                      );
                      _undoStack.add(_currentTextState!);
                      _redoStack.clear();
                    }
                  });
                },
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                icon: Icon(Icons.format_italic,
                    color: _currentTextState?.isItalic == true
                        ? Colors.blue
                        : Colors.white),
                onPressed: () {
                  setState(() {
                    if (_currentTextState != null) {
                      _currentTextState = TextState(
                        position: _currentTextState!.position,
                        isBold: _currentTextState!.isBold,
                        isItalic: !_currentTextState!.isItalic,
                        fontFamily: _currentTextState!.fontFamily,
                      );
                      _undoStack.add(_currentTextState!);
                      _redoStack.clear();
                    }
                  });
                },
              ),
            ),
            SizedBox(
              width: 90,
              child: DropdownButton<String>(
                value: _currentTextState?.fontFamily ?? 'Roboto',
                dropdownColor: Colors.deepPurple[200],
                underline: SizedBox(),
                icon: Icon(Icons.text_fields, color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    if (_currentTextState != null && newValue != null) {
                      _currentTextState = TextState(
                        position: _currentTextState!.position,
                        isBold: _currentTextState!.isBold,
                        isItalic: _currentTextState!.isItalic,
                        fontFamily: newValue,
                      );
                      _undoStack.add(_currentTextState!);
                      _redoStack.clear();
                    }
                  });
                },
                items: _fontStyles.map<DropdownMenuItem<String>>((String font) {
                  return DropdownMenuItem<String>(
                    value: font,
                    child: Text(
                      font,
                      style: TextStyle(fontFamily: font, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo, color: Colors.white),
            onPressed: (_undoStack.isNotEmpty)
                ? () {
                    setState(() {
                      if (_currentTextState?.position != null &&
                          _undoStack.length != 1) {
                        _redoStack.add(_currentTextState!);
                        _undoStack.removeLast();
                        _currentTextState =
                            _undoStack.elementAt(_undoStack.length - 1);
                      }
                    });
                  }
                : null, // Disable if no undo is available
          ),
          IconButton(
            icon: Icon(
              Icons.redo,
              color: Colors.white,
            ),
            onPressed: _redoStack.isNotEmpty
                ? () {
                    setState(() {
                      if (_currentTextState != null) {
                        _undoStack.add(_redoStack.last);
                      }
                      _currentTextState = _redoStack.removeLast();
                    });
                  }
                : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_currentTextState != null)
            Positioned(
              left: _currentTextState!.position.dx,
              top: _currentTextState!.position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // Update position while enforcing boundaries
                    Offset newPosition = Offset(
                      (_currentTextState!.position.dx + details.delta.dx)
                          .clamp(0.0, screenSize.width - 60), // Text width ~100
                      (_currentTextState!.position.dy + details.delta.dy).clamp(
                          0.0, screenSize.height - 120), // Text height ~50
                    );
                    _currentTextState = TextState(
                      position: newPosition,
                      isBold: _currentTextState!.isBold,
                      isItalic: _currentTextState!.isItalic,
                      fontFamily: _currentTextState!.fontFamily,
                    );
                  });
                },
                onPanEnd: (details) {
                  // Save position to undo stack
                  setState(() {
                    if (_currentTextState != null) {
                      print("Not Null");

                      _undoStack.add(_currentTextState!);
                      _redoStack.clear();
                      // print("LENGTH: ${_undoStack.length}");
                    }
                  });
                },
                child: Text(
                  'Canvas',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: _currentTextState!.isBold
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontStyle: _currentTextState!.isItalic
                        ? FontStyle.italic
                        : FontStyle.normal,
                    fontFamily: _currentTextState!.fontFamily,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
