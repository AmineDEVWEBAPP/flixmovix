import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageUrl});
  final String? imageUrl;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          width: Get.width * 0.45,
          imageUrl ?? '',
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.red),
        ),
      );
}
