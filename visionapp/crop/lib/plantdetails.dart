import 'package:flutter/material.dart';
import 'dart:io';

class PlantDetailScreen extends StatelessWidget {
  final File image;
  final String plantClass;
  final double confidence;

  const PlantDetailScreen({
    super.key,
    required this.image,
    required this.plantClass,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.file(
                image,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plantClass.split('_')[0],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Outdoor plant',
              style: TextStyle(color: Color.fromARGB(255, 104, 103, 103)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlantInfo(
                    icon: Icons.vaccines_outlined,
                    label: 'Disease',
                    subLabel: plantClass),
                PlantInfo(
                    icon: Icons.auto_graph_outlined, label: 'Confidence', subLabel:confidence.toString()),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'General information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Introduce a touch of freshness and sophistication to your home or office with our Natural Looking Artificial Aloe Vera.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;

  const PlantInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          subLabel,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
