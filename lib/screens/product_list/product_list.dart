// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/product_search_cubit.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/product_details/product_details.dart';
import 'package:mini_wheelz/widgets/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({super.key});

  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> uploadImagesToCloudinary(List<File> files) async {
    const cloudName = 'dxpt9leg6';
    const uploadPreset = 'Mini_Wheelz';
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    List<String> imageUrls = [];

    for (var file in files) {
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        imageUrls.add(data['secure_url']);
      }
    }

    return imageUrls;
  }

  void _deleteProduct(BuildContext context, String productId) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Product deleted')));
  }

  @override
  Widget build(BuildContext context) {
    final productsRef = FirebaseFirestore.instance.collection('products');
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isTablet =
        MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1024;

    return BlocProvider(
      create: (_) => ProductSearchCubit(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: BlocBuilder<ProductSearchCubit, String>(
                builder: (context, query) {
                  return TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name or category',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: textSecondary,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) =>
                        context.read<ProductSearchCubit>().updateQuery(value),
                  );
                },
              ),
            ),

            // 📦 Products list
            Expanded(
              child: BlocBuilder<ProductSearchCubit, String>(
                builder: (context, searchQuery) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: productsRef
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: redColor),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ShimmerPlaceholder();
                      }

                      final docs = snapshot.data?.docs ?? [];
                      final filteredDocs = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final name = (data['name'] ?? '').toLowerCase();
                        final category = (data['category'] ?? '').toLowerCase();
                        return name.contains(searchQuery.toLowerCase()) ||
                            category.contains(searchQuery.toLowerCase());
                      }).toList();

                      if (filteredDocs.isEmpty) {
                        return Center(
                          child: Text(
                            'No products found.',
                            style: TextStyle(color: greyColor),
                          ),
                        );
                      }

                      // 🔥 Responsive: Grid for tablet/desktop, List for mobile
                      if (isMobile) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredDocs.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildProductCard(context, filteredDocs[index]),
                        );
                      } else {
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredDocs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isTablet ? 2 : 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 3,
                              ),
                          itemBuilder: (context, index) =>
                              _buildProductCard(context, filteredDocs[index]),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🛠 Product Card widget (with shimmer for image loading)
  Widget _buildProductCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final images = List<String>.from(data['images'] ?? []);
    final firstImage = images.isNotEmpty ? images[0] : '';

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProductDetailPage(productData: {...data, 'id': doc.id}),
        ),
      ),
      child: Card(
        color: whiteColor,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 🖼 Image with shimmer effect
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: firstImage.isNotEmpty
                      ? Stack(
                          children: [
                            // Shimmer background
                            Shimmer.fromColors(
                              baseColor: shimmerBase,
                              highlightColor: shimmerHighlight,
                              child: Container(
                                width: 70,
                                height: 70,
                                color: whiteColor,
                              ),
                            ),
                            // Actual image
                            Image.network(
                              firstImage,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(); // shimmer stays
                                  },
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        )
                      : const Icon(Icons.image, size: 40, color: textSecondary),
                ),
              ),
              const SizedBox(width: 12),

              // 📑 Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    Text(
                      'Category: ${data['category']}',
                      style: TextStyle(color: greyColor),
                    ),
                    Text(
                      '₹ ${data['price']} | QTY  ${data['quantity']}  | ${(data['unit'] ?? '').replaceFirst(RegExp(r'^per\s*', caseSensitive: false), '')}',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),

              // 🗑 Delete button
              IconButton(
                icon: const Icon(Icons.delete, color: errorColor),
                onPressed: () => _deleteProduct(context, doc.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
