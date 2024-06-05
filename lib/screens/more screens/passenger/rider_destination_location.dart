import 'package:caravan/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:caravan/components/location_search_widget.dart';

class DestinationSelectionScreen extends StatefulWidget {
  const DestinationSelectionScreen({super.key});

  @override
  _DestinationSelectionScreenState createState() =>
      _DestinationSelectionScreenState();
}

class _DestinationSelectionScreenState
    extends State<DestinationSelectionScreen> {
  TextEditingController destinationFieldController = TextEditingController();
  var locationSuggestions = [];
  LocationService locationService = LocationService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Destination')),
      body: LocationSearchWidget(
        controller: destinationFieldController,
        hintText: 'Enter Destination',
        icon: Icons.location_on,
        onChanged: (textFieldValue) {
          locationService.getLocationSuggestions(textFieldValue).then((value) {
            setState(() {
              locationSuggestions = value;
            });
          });
        },
        locationSuggestions: locationSuggestions.cast<Map<String, dynamic>>(),
        onSuggestionTap: (suggestion) {
          // Handle suggestion tap
        },
      ),
    );
  }
}
