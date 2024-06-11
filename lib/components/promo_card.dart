import 'dart:ui';

import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const PromoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Add border radius
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Blur effect
            // Positioned.fill(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10), // Match border radius
            //     child: BackdropFilter(
            //       blendMode: BlendMode.darken,
            //       filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            //       child: Container(
            //         color: Colors.black.withOpacity(0.1),
            //       ),
            //     ),
            //   ),
            // ),
            // Title and description
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // Match border radius
                  child: BackdropFilter(
                    blendMode: BlendMode.darken,
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      height: 70,
                      color: Colors.black.withOpacity(0.3),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                // color: Colors.black.withOpacity(0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
