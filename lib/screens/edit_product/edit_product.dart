// ignore_for_file: sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/edit_product_cubit.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/widgets/enhanced_ui_components.dart';

class EditProductScreen extends StatelessWidget {
  final String productId;
  final Map<String, dynamic> initialData;

  EditProductScreen({
    super.key,
    required this.productId,
    required this.initialData,
  });

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();
  final categoryController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  void initializeControllers() {
    nameController.text = initialData['name'];
    descriptionController.text = initialData['description'];
    priceController.text = initialData['price'].toString();
    quantityController.text = initialData['quantity'].toString();
    unitController.text = initialData['unit'];
    categoryController.text = initialData['category'];
  }

  Future<void> _replaceImages(BuildContext context) async {
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((e) => File(e.path)).toList();
        context.read<EditProductCubit>().replaceImages(files);
      }
    } catch (e) {
      _showErrorSnackBar(context, "Error picking images: $e");
    }
  }

  void _updateProduct(BuildContext context, List<String> imageUrls) async {
    if (_validateInputs(context)) {
      _showLoadingDialog(context);

      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .update({
              'name': nameController.text.trim(),
              'description': descriptionController.text.trim(),
              'price': int.tryParse(priceController.text.trim()) ?? 0,
              'quantity': int.tryParse(quantityController.text.trim()) ?? 0,
              'unit': unitController.text.trim(),
              'category': categoryController.text.trim(),
              'images': imageUrls,
            });

        Navigator.of(context).pop(); // Close loading dialog
        _showSuccessSnackBar(context, 'Product updated successfully!');
        Navigator.of(context).pop(true);
      } catch (e) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorSnackBar(context, 'Failed to update product: $e');
      }
    }
  }

  bool _validateInputs(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      _showErrorSnackBar(context, 'Product name is required');
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      _showErrorSnackBar(context, 'Price is required');
      return false;
    }
    return true;
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          EnhancedUIComponents.loadingWidget(message: 'Updating product...'),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    EnhancedUIComponents.showSuccessSnackBar(context, message);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    EnhancedUIComponents.showErrorSnackBar(context, message);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: EnhancedUIComponents.enhancedInputField(
        controller: controller,
        label: label,
        prefixIcon: icon,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildImageSection(EditProductState state, BuildContext context) {
    return EnhancedUIComponents.enhancedCard(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.photo_library, color: primaryColor, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Product Images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.imageUrls.isNotEmpty)
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.imageUrls.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      state.imageUrls[index],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: borderGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: borderGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.error, color: errorColor),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderGrey, style: BorderStyle.solid),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, size: 32, color: textSecondary),
                    const SizedBox(height: 8),
                    Text(
                      'No images selected',
                      style: TextStyle(color: textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          EnhancedUIComponents.secondaryButton(
            text: 'Replace Images',
            icon: Icons.add_photo_alternate,
            onPressed: () => _replaceImages(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeControllers();
    final initialImages = List<String>.from(initialData['images'] ?? []);

    return BlocProvider(
      create: (_) => EditProductCubit(initialImages),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: EnhancedUIComponents.gradientAppBar(
          title: "Edit Product",
          centerTitle: true,
        ),
        body: BlocBuilder<EditProductCubit, EditProductState>(
          builder: (context, state) {
            if (state.isLoading) {
              return EnhancedUIComponents.loadingWidget(
                message: 'Loading product details...',
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Update your product details below',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Image Section
                  _buildImageSection(state, context),

                  // Form Section
                  EnhancedUIComponents.enhancedCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit, color: primaryColor, size: 24),
                            const SizedBox(width: 12),
                            const Text(
                              'Product Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: nameController,
                          label: "Product Name",
                          icon: Icons.inventory_2_outlined,
                          hint: "Enter product name",
                        ),

                        _buildTextField(
                          controller: descriptionController,
                          label: "Description",
                          icon: Icons.description_outlined,
                          maxLines: 3,
                          hint: "Describe your product",
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: priceController,
                                label: "Price",
                                icon: Icons.currency_rupee,
                                keyboardType: TextInputType.number,
                                hint: "0",
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: quantityController,
                                label: "Quantity",
                                icon: Icons.numbers,
                                keyboardType: TextInputType.number,
                                hint: "0",
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: unitController,
                                label: "Scale",
                                icon: Icons.straighten,
                                hint: "Select Scale",
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: categoryController,
                                label: "Category",
                                icon: Icons.category_outlined,
                                hint: "Select category",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  EnhancedUIComponents.primaryButton(
                    text: "Save Changes",
                    icon: Icons.save_outlined,
                    onPressed: () => _updateProduct(context, state.imageUrls),
                    width: double.infinity,
                    height: 56,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
