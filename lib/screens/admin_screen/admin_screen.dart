import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/admin_orders_bloc.dart';
import 'package:mini_wheelz/bloc/dashboard_bloc.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/screens/add_category/add_category.dart';
import 'package:mini_wheelz/screens/add_product/add_products.dart';
import 'package:mini_wheelz/screens/home/home.dart';
import 'package:mini_wheelz/screens/order_screen/orders_screen.dart';
import 'package:mini_wheelz/screens/product_list/product_list.dart';
import 'package:mini_wheelz/screens/revenue/revenue.dart';
import 'package:mini_wheelz/widgets/shimmer.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({super.key});

  final List<Widget> _screens = [
    EarningsScreen(),

    BlocProvider(
      create: (_) => AdminOrdersBloc(),
      child: const AdminOrdersScreen(),
    ),
    AddCategoryPage(),
    AddProductPage(),
    ProductListPage(),
  ];

  final List<String> _titles = [
    'Revenue Dashboard',
    'Orders Management', 
    'Add Category',
    'Add Product',
    'My Products',
  ];
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(),
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final selectedIndex = state.selectedIndex;

          return Scaffold(
            backgroundColor: whiteColor,
            appBar: AppBar(
              title: Text(_titles[selectedIndex]),
              backgroundColor: primaryColor,
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_4_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => UsersListPage()),
                    );
                  },
                  tooltip: 'Revenue',
                  color: whiteColor,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: _signOut,
                  tooltip: 'Sign Out',
                  color: whiteColor,
                ),
              ],
            ),
            body: state.isLoading
                ? const ShimmerPlaceholder()
                : _screens[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(


              type: BottomNavigationBarType.fixed,
              backgroundColor: whiteColor,

              selectedItemColor: primaryColor,
              unselectedItemColor: greyColor,
              currentIndex: selectedIndex,
              onTap: (index) {
                context.read<DashboardBloc>().add(DashboardTabChanged(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.currency_rupee_rounded),
                  label: 'Revenue',
                ),
                BottomNavigationBarItem(
                   
                  icon: Icon(Icons.shopping_bag),
                  label: 'Orders',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Category',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_box),
                  label: 'Product',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'My Products',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
