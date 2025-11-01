import 'package:flutter/material.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget buildLoadingState() {
  return Column(
    children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: shimmerBase,
          highlightColor: shimmerHighlight,
          child: Container(
            decoration: BoxDecoration(
              color: shimmerBase,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
      Shimmer.fromColors(
        baseColor: shimmerBase,
        highlightColor: shimmerHighlight,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: shimmerBase,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    ],
  );
}
