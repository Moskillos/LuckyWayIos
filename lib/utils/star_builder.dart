import 'package:flutter/material.dart';

Widget buildRatingStars(double rating) {
  assert(rating >= 0 && rating <= 5);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: List.generate(5, (index) {
      if (index < rating.floor()) {
        // Stella piena
        return const Icon(Icons.star, color: Colors.amber);
      } else if (index < rating && rating - index >= 0.5) {
        // Mezza stella
        return const Icon(Icons.star_half, color: Colors.amber);
      } else {
        // Stella vuota
        return const Icon(Icons.star_border, color: Colors.amber);
      }
    }),
  );
}