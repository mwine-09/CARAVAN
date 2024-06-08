import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;

  const MyTextField({
    required this.label,
    required this.controller,
    this.textColor = const Color.fromARGB(255, 0, 0, 0),
    this.backgroundColor = const Color.fromARGB(96, 150, 146, 146),
    this.borderRadius = 10.0,
    super.key,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
              color: widget.backgroundColor,
            ),
            child: TextField(
              controller: widget.controller,
              style: TextStyle(color: widget.textColor),
              cursorColor: widget.textColor,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
