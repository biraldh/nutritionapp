import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class FoodDetectionPage extends StatefulWidget {
  @override
  _FoodDetectionPageState createState() => _FoodDetectionPageState();
}

class _FoodDetectionPageState extends State<FoodDetectionPage> {
  File? _imageFile;
  String? _detectedFood;
  String? _weight;
  String? _calories;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  /// Captures an image using the camera.
  Future<void> _captureImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _detectedFood = null;
          _weight = null;
          _calories = null;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to capture image: $e');
    }
  }
  Future<void> _GalleryImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _detectedFood = null;
          _weight = null;
          _calories = null;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to get image: $e');
    }
  }

  /// Uploads the captured image to the API and fetches the response.
  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      _showSnackBar('Please capture an image first');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiEndpoint = dotenv.env['API_ENDPOINT'];
    if (apiEndpoint == null || apiEndpoint.isEmpty) {
      _showSnackBar('API endpoint is not configured');
      setState(() => _isLoading = false);
      return;
    }

    final uri = Uri.parse(apiEndpoint);
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        setState(() {
          _detectedFood = jsonData['food'] ?? 'Unknown';
          _weight = jsonData['weight'] != null
              ? double.parse(jsonData['weight'].toString()).toStringAsFixed(2)
              : 'N/A';
          _calories = jsonData['calories'] != null
              ? double.parse(jsonData['calories'].toString()).toStringAsFixed(2)
              : 'N/A';
        });
      } else {
        _handleError('API returned status code: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  void _handleError(String message) {
    setState(() {
      _detectedFood = 'Error';
      _weight = null;
      _calories = null;
    });
    _showSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Detection App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the captured image or a placeholder text.
              _imageFile != null
                  ? Image.file(
                _imageFile!,
                height: 200,
              )
                  : Text(
                'No image captured',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Capture image button.
              ElevatedButton(
                onPressed: _captureImage,
                child: Text('Capture Image'),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _GalleryImage,
                child: Text('Gallery'),
              ),
              SizedBox(height: 20),

              // Upload image button with a loading indicator.
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadImage,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Upload Image'),
              ),
              SizedBox(height: 20),

              // Display detected food, weight, and calories if available.
              if (_detectedFood != null && _weight != null && _calories != null)
                Column(
                  children: [
                    Text(
                      'Detected Food: $_detectedFood',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Weight: $_weight grams',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Calories: $_calories kcal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
