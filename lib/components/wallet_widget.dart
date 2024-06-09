import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;
  final double imageSize;

  const ActionCard({
    required this.imagePath,
    required this.label,
    required this.onPressed,
    required this.imageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: const Color.fromARGB(255, 255, 255, 255),
        elevation: 5, // Add elevation for shadow effect
        shadowColor:
            const Color.fromARGB(255, 0, 0, 0), // Set shadow color to black
// Offset the shadow on the x-axis
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Image.asset(
                    imagePath,
                    width: imageSize,
                    height: imageSize,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
