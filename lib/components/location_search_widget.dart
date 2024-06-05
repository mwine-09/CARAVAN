import 'package:flutter/material.dart';

class LocationSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Function(String) onChanged;
  final List<dynamic> locationSuggestions;
  final Function(Map<String, dynamic>) onSuggestionTap;

  const LocationSearchWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    required this.locationSuggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: onChanged,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: locationSuggestions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onSuggestionTap(locationSuggestions[index]),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.black),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          locationSuggestions[index]['description'],
                          style: const TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
