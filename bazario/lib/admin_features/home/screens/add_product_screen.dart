// dart format width=80
import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/image_upload_service.dart';
import '../../../utils/constants/colors.dart';

@RoutePage()
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  XFile? _pickedImage;
  String? _selectedCategory;
  String? _selectedFlashSaleType;

  final List<String> _categories = [
    'T-Shirt',
    'Pant',
    'Dress',
    'Jacket',
    'Electronics',
    'Books',
  ];

  final List<String> _flashSaleFilters = [
    'All',
    'Newest',
    'Popular',
    'Man',
    'Woman',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate() &&
        _selectedCategory != null &&
        _selectedFlashSaleType != null) {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final imageUrl = await uploadImageToCloudinary(File(_pickedImage!.path));

        if (imageUrl == null) {
          throw Exception('Failed to get image URL from Cloudinary.');
        }

        await FirebaseFirestore.instance.collection('products').add({
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'imageUrl': imageUrl,
          'category': _selectedCategory,
          'flashSaleType': _selectedFlashSaleType,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
        Navigator.of(context).pop();
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both a category and a flash sale type.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New Product',
          style: TextStyle(
              color: Colors.white, fontFamily: "Urbanist", fontSize: 24),
        ),
        backgroundColor: MyColors.kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a product name.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a description.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a price.';
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a category.' : null,
              ),
              const SizedBox(height: 16),
              // Flash Sale Dropdown
              DropdownButtonFormField<String>(
                value: _selectedFlashSaleType,
                decoration: const InputDecoration(labelText: 'Flash Sale Type'),
                items: _flashSaleFilters.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFlashSaleType = newValue;
                  });
                },
                validator: (value) => value == null
                    ? 'Please select a flash sale type.'
                    : null,
              ),
              const SizedBox(height: 24),
              _pickedImage != null
                  ? Image.file(
                File(_pickedImage!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              )
                  : const Text('No image selected.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.kPrimaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}