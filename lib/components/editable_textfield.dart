import 'package:flutter/material.dart';

class EditableProfileField extends StatefulWidget {
  final String label;
  final String? value;
  final void Function(String) onSave;

  const EditableProfileField({
    required this.label,
    required this.value,
    required this.onSave,
    super.key,
  });

  @override
  _EditableProfileFieldState createState() => _EditableProfileFieldState();
}

class _EditableProfileFieldState extends State<EditableProfileField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.grey,
              ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Enter ${widget.label.toLowerCase()}',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white.withOpacity(0.5),
                        )),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                widget.onSave(_controller.text);
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
