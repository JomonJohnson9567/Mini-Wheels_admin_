import 'package:flutter/material.dart';
import 'package:mini_wheelz/screens/revenue/widget/build_context.dart';

Widget buildMobileLayout(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: buildContent(context),
  );
}

Widget buildTabletLayout(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: buildContent(context),
      ),
    ),
  );
}

Widget buildDesktopLayout(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(32),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: buildContent(context),
      ),
    ),
  );
}
