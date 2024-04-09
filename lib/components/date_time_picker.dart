import 'package:flutter/material.dart';

class DepartureTimePicker extends StatefulWidget {
  final ValueChanged<DateTime>? onChanged;

  const DepartureTimePicker({super.key, this.onChanged});

  @override
  _DepartureTimePickerState createState() => _DepartureTimePickerState();
}

class _DepartureTimePickerState extends State<DepartureTimePicker> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
        widget.onChanged?.call(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Departure Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedDate.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: const Text('Select Time'),
            ),
          ],
        ),
      ],
    );
  }
}
