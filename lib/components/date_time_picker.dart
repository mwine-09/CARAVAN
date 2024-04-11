import 'package:flutter/material.dart';

class DepartureTimePicker extends StatefulWidget {
  final ValueChanged<DateTime>? onChanged;

  const DepartureTimePicker({super.key, this.onChanged});

  @override
  _DepartureTimePickerState createState() => _DepartureTimePickerState();
}

class _DepartureTimePickerState extends State<DepartureTimePicker> {
  DateTime _selectedDate = DateTime.now();

  void _selectDateTime(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDate),
        ).then((pickedTime) {
          if (pickedTime != null) {
            setState(() {
              _selectedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            });
            widget.onChanged?.call(_selectedDate);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(
          'Departure Time',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontSize: 16,
          )
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                )
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              onPressed: () => _selectDateTime(context),
              child: const Text('Select Time'),
            ),
          ],
        ),
      ],
    );
  }
}
