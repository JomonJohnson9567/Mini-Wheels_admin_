import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_wheelz/bloc/product_bloc.dart';
import 'package:mini_wheelz/bloc/product_event.dart';
import 'package:mini_wheelz/bloc/product_form/product_form_cubit.dart';
import 'package:mini_wheelz/bloc/product_state.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/add_product/widget/decoration.dart';
import 'package:mini_wheelz/screens/add_product/widget/product_adding_gif.dart';
import 'package:mini_wheelz/screens/product_list/product_list.dart';
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
              color: textPrimary,
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
          buildSectionTitle('Product Images', Icons.photo_library_outlined),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: lightGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: formState.imageBytes.isEmpty
                    ? borderGrey
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
                    color: textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "No images selected",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add product images to showcase your item",
                    style: const TextStyle(color: textSecondary, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ] else ...[
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: formState.imageBytes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: blackColor.withOpacity(0.1),
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
                          // Delete button
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                context.read<ProductFormCubit>().removeImage(i);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: errorColor.withOpacity(0.8),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: blackColor.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: whiteColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "${formState.imageBytes.length} image${formState.imageBytes.length > 1 ? 's' : ''} selected",
                    style: TextStyle(
                      color: textSecondary,
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

          TextFormField(
            controller: nameController,
            decoration: decoration('Product Name', Icons.shopping_bag_outlined),
            style: const TextStyle(fontSize: 15),
            validator: (v) => v!.isEmpty ? 'Enter product name' : null,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: descriptionController,
            decoration: decoration('Description', Icons.description_outlined),
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
                  decoration: decoration('Price', Icons.currency_rupee),
                  style: const TextStyle(fontSize: 15),
                  validator: (v) => v!.isEmpty ? 'Enter price' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: decoration('Quantity', Icons.inventory_outlined),
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
              color: lightGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderGrey, width: 1.5),
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
                labelStyle: const TextStyle(color: textSecondary, fontSize: 15),
              ),
              hint: Text(
                "Select Scale Unit",
                style: const TextStyle(color: textSecondary),
              ),
              validator: (v) => v == null ? 'Select unit' : null,
              onChanged: (v) => context.read<ProductFormCubit>().setUnit(v),
              dropdownColor: whiteColor,
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
                    color: lightGrey,
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
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderGrey, width: 1.5),
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
                    labelStyle: const TextStyle(
                      color: textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  hint: Text(
                    "Select Category",
                    style: const TextStyle(color: textSecondary),
                  ),
                  validator: (v) => v == null ? 'Select category' : null,
                  onChanged: (v) =>
                      context.read<ProductFormCubit>().setCategory(v),
                  dropdownColor: whiteColor,
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
                backgroundColor: successColor,
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
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: whiteColor,
            elevation: 0,

            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: textPrimary),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ProductListPage()),
              ),
            ),
          ),
          body: BlocBuilder<AddProductBloc, AddProductState>(
            builder: (context, addState) {
              if (addState is AddProductLoading) {
                return product_adding_gif();
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
