import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/product_bloc.dart';
import 'package:mini_wheelz/bloc/product_event.dart';
import 'package:mini_wheelz/bloc/product_form/product_form_cubit.dart';
import 'package:mini_wheelz/bloc/product_state.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/widgets/responsive.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMultipleImages(BuildContext context) async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final imageBytes = await Future.wait(
        pickedFiles.map((f) => f.readAsBytes()),
      );
      final imageNames = pickedFiles.map((f) => f.name).toList();
      context.read<ProductFormCubit>().setImageBytes(imageBytes, imageNames);
    }
  }

  void submitProduct(BuildContext context, ProductFormState formState) {
    if (!_formKey.currentState!.validate() || formState.imageBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Please fill all required fields and add images'),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    final selectedUnit = formState.selectedUnit;
    final selectedCategory = formState.selectedCategory;
    if (selectedUnit == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Please select unit and category')),
            ],
          ),
          backgroundColor: Colors.blue.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }
    context.read<AddProductBloc>().add(
      AddProductSubmitted(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: int.tryParse(priceController.text) ?? 0,
        quantity: int.tryParse(quantityController.text) ?? 0,
        unit: selectedUnit,
        category: selectedCategory,
        imageBytes: formState.imageBytes,
        imageNames: formState.imageNames,
      ),
    );
  }

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: primaryColor, size: 22),
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor, width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      borderRadius: BorderRadius.circular(16),
    ),
    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 15),
  );

  Widget buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProductFormState formState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('Basic Information', Icons.info_outline),

          TextFormField(
            controller: nameController,
            decoration: _decoration(
              'Product Name',
              Icons.shopping_bag_outlined,
            ),
            style: const TextStyle(fontSize: 15),
            validator: (v) => v!.isEmpty ? 'Enter product name' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: descriptionController,
            decoration: _decoration('Description', Icons.description_outlined),
            style: const TextStyle(fontSize: 15),
            maxLines: 4,
          ),
          const SizedBox(height: 24),

          buildSectionTitle('Pricing & Stock', Icons.attach_money),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: _decoration('Price', Icons.currency_rupee),
                  style: const TextStyle(fontSize: 15),
                  validator: (v) => v!.isEmpty ? 'Enter price' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: _decoration('Quantity', Icons.inventory_outlined),
                  style: const TextStyle(fontSize: 15),
                  validator: (v) => v!.isEmpty ? 'Enter quantity' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          buildSectionTitle('Product Details', Icons.category_outlined),

          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: DropdownButtonFormField<String>(
              value: formState.selectedUnit,
              decoration: InputDecoration(
                labelText: "Scale Unit",
                prefixIcon: const Icon(
                  Icons.straighten,
                  color: primaryColor,
                  size: 22,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),
              hint: Text(
                "Select Scale Unit",
                style: TextStyle(color: Colors.grey.shade500),
              ),
              validator: (v) => v == null ? 'Select unit' : null,
              onChanged: (v) => context.read<ProductFormCubit>().setUnit(v),
              dropdownColor: Colors.white,
              icon: Icon(
                Icons.arrow_drop_down_circle_outlined,
                color: primaryColor,
              ),
              items: ['1/64 Scale', '1/43 Scale', '1/32 Scale', '1/24 Scale']
                  .map(
                    (u) => DropdownMenuItem(
                      value: u,
                      child: Text(u, style: const TextStyle(fontSize: 15)),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                );
              }
              final categories = snapshot.data!.docs
                  .map((d) => d['name'] as String)
                  .toList();
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: DropdownButtonFormField<String>(
                  value: formState.selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Category",
                    prefixIcon: const Icon(
                      Icons.category,
                      color: primaryColor,
                      size: 22,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                    ),
                  ),
                  hint: Text(
                    "Select Category",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  validator: (v) => v == null ? 'Select category' : null,
                  onChanged: (v) =>
                      context.read<ProductFormCubit>().setCategory(v),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: primaryColor,
                  ),
                  items: categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c, style: const TextStyle(fontSize: 15)),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          buildSectionTitle('Product Images', Icons.photo_library_outlined),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: formState.imageBytes.isEmpty
                    ? Colors.grey.shade300
                    : primaryColor.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                if (formState.imageBytes.isEmpty) ...[
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No images selected",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add product images to showcase your item",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: formState.imageBytes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            formState.imageBytes[i],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${formState.imageBytes.length} image${formState.imageBytes.length > 1 ? 's' : ''} selected",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _pickMultipleImages(context),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: Text(
                    formState.imageBytes.isEmpty
                        ? "Select Images"
                        : "Add More Images",
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor, width: 1.5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => submitProduct(context, formState),
              icon: const Icon(Icons.add_circle_outline, size: 22),
              label: const Text(
                "Add Product",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 2,
                shadowColor: primaryColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFormCubit(),
      child: BlocListener<AddProductBloc, AddProductState>(
        listener: (context, state) {
          if (state is AddProductSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(child: Text('Product added successfully')),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
            nameController.clear();
            descriptionController.clear();
            priceController.clear();
            quantityController.clear();
            context.read<ProductFormCubit>().resetForm();
          } else if (state is AddProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,
            title: const Text(
              'Add New Product',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<AddProductBloc, AddProductState>(
            builder: (context, addState) {
              if (addState is AddProductLoading) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'lib/assets/image/car-7004_256.gif',
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Adding Product...',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please wait while we save your product',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 240,
                        height: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return BlocBuilder<ProductFormCubit, ProductFormState>(
                builder: (context, formState) {
                  return ResponsiveLayout(
                    mobile: (_) => Container(
                      color: whiteColor,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: _buildForm(context, formState),
                      ),
                    ),
                    tablet: (_) => Center(
                      child: Container(
                        width: 600,
                        color: whiteColor,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: _buildForm(context, formState),
                        ),
                      ),
                    ),
                    desktop: (_) => Center(
                      child: Container(
                        width: 800,
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(48),
                          child: _buildForm(context, formState),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
