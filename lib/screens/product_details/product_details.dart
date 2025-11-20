import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/product_detail_cubit.dart';
import 'package:mini_wheelz/screens/edit_product/edit_product.dart';
import 'package:mini_wheelz/screens/product_details/widget/circle_button.dart';
import 'package:mini_wheelz/screens/product_details/widget/infocard_widget.dart';
import 'package:mini_wheelz/widgets/cards_widgets.dart';
import 'package:mini_wheelz/widgets/confirm_delete_product.dart';
import 'package:mini_wheelz/core/colors.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductDetailPage({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    final productId = productData['id'];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductDetailCubit()..fetchProduct(productId),
        ),
        BlocProvider(create: (_) => ImageCarouselCubit()),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: circleButton(
            context,
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.pop(context),
          ),
          actions: [
            circleButton(
              context,
              icon: Icons.edit_outlined,
              onTap: () async {
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProductScreen(
                      productId: productId,
                      initialData: productData,
                    ),
                  ),
                );
                if (updated == true) {
                  context.read<ProductDetailCubit>().fetchProduct(productId);
                }
              },
            ),
            const SizedBox(width: 8),
            circleButton(
              context,
              icon: Icons.delete_outline,
              color: errorColor,
              onTap: () => confirmDelete(context, productId),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final data = state.product!;
            final List<String> images = List<String>.from(data['images'] ?? []);

            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔥 Hero Carousel
                      if (images.isNotEmpty)
                        Hero(
                          tag: "product_$productId",
                          child: ImageCarousel(images: images, height: 380),
                        )
                      else
                        Container(
                          height: 380,
                          color: lightGrey,
                          child: const Center(
                            child: Icon(Icons.image, size: 80),
                          ),
                        ),

                      // 🔥 Glassmorphic Content
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              offset: Offset(0, -8),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Title
                            Text(
                              data['name'] ?? "No Name",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Category chip
                            Chip(
                              avatar: const Icon(
                                Icons.category_outlined,
                                size: 18,
                                color: whiteColor,
                              ),
                              label: Text(
                                data['category'] ?? "Unknown",
                                style: const TextStyle(color: whiteColor),
                              ),
                              backgroundColor: primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Price & Stock Cards
                            Row(
                              children: [
                                Expanded(
                                  child: infoCard(
                                    title: "Price",
                                    value:
                                        "₹${(data['price'] ?? 0).toStringAsFixed(2)}",
                                    icon: Icons.currency_rupee,
                                    color1: const Color(0xFF6A11CB),
                                    color2: const Color(0xFF2575FC),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: infoCard(
                                    title: "In Stock",
                                    value:
                                        " ${data['quantity'] ?? 0} |${data['unit'] ?? ""}",
                                    icon: Icons.inventory_2_outlined,
                                    color1: const Color(0xFFFF6A00),
                                    color2: const Color(0xFFFFC107),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Description
                            Text(
                              "Description",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              data['description'] ??
                                  "No description available.",
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: textSecondary,
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double height;

  const ImageCarousel({super.key, required this.images, this.height = 300});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) =>
                context.read<ImageCarouselCubit>().updatePage(index),
            itemBuilder: (context, index) {
              final url = widget.images[index];
              return Container(
                color: lightGrey,
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: widget.height,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 64)),
                ),
              );
            },
          ),

          // Dots indicator
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: BlocBuilder<ImageCarouselCubit, int>(
                builder: (context, current) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.images.length, (i) {
                      final active = i == current;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? Colors.blue : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
