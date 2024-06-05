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
    DateTime now = DateTime.now();
    DateTime oneWeekAhead = now.add(const Duration(days: 7));

    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: oneWeekAhead,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary), // Ok and Cancel buttons
            dialogBackgroundColor:
                Colors.white, // Background color of the date picker
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black), // Body text color
              bodyMedium: TextStyle(color: Colors.black), // Body text color
              labelLarge: TextStyle(color: Colors.black), // Button text color
            ),
            colorScheme: const ColorScheme.light(primary: Colors.black)
                .copyWith(secondary: Colors.white),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(_selectedDate),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.black,
                buttonTheme: const ButtonThemeData(
                    textTheme:
                        ButtonTextTheme.primary), // Ok and Cancel buttons
                dialogBackgroundColor:
                    Colors.white, // Background color of the time picker
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: Colors.black), // Body text color
                  bodyMedium: TextStyle(color: Colors.black), // Body text color
                  labelLarge:
                      TextStyle(color: Colors.black), // Button text color
                ),
                colorScheme: const ColorScheme.light(primary: Colors.black)
                    .copyWith(secondary: Colors.white),
              ),
              child: child!,
            );
          },
        ).then((pickedTime) {
          if (pickedTime != null) {
            DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            // Ensure the selected date and time is not older than the current time
            if (selectedDateTime.isBefore(now)) {
              selectedDateTime = now;
            }

            setState(() {
              _selectedDate = selectedDateTime;
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
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                    ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
