import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crop/plantdetails.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendImageToServer() async {
    if (_image == null) {
      print("No image selected.");
      return;
    }

    final bytes = await _image!.readAsBytes();
    String base64Image = base64Encode(bytes);

    Map<String, String> body = {
      "base64": base64Image,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.207:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {

        Map<String, dynamic> responseBody = json.decode(response.body);

        String plantClass = responseBody["class"];
        double confidence = responseBody["confidence"];

        print('Class: $plantClass');
        print('Confidence: $confidence');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(
              image: _image!,
              plantClass: plantClass,
              confidence: confidence,
            ),
          ),
        );
      } else {
        print('Failed: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
        title: const Text(
          'Upload Image',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Icon(
                Icons.image,
                color: Colors.green,
                size: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upload a New Plant Image',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Showcase your plants by uploading their images here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            _image != null
                ? Image.file(
                    _image!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : const Text('No image selected'),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _pickImage,
              child: const Text(
                'Upload Image from Gallery',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                _sendImageToServer(); 
              },
              child: const Text(
                'Proceed to Plant Details',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
