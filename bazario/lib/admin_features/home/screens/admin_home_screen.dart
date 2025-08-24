// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/admin_features/home/screens/widgets/build_admin_card.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:bazario/app/app_router.gr.dart';

@RoutePage()
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard',style: TextStyle(
          color: Colors.white,
          fontFamily: "Urbanist",
          fontSize: 24
        ),),
        backgroundColor: MyColors.kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: MyColors.secondaryPrimaryColor,
                fontFamily: "Urbanist"
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage your application content and users.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Section for Product Management
            const Text(
              'Product Management',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MyColors.kPrimaryColor,
                fontFamily: "Urbanist"
              ),
            ),
            const Divider(),
            AdminCard(
              icon: Icons.add_photo_alternate,
              title: 'Add New Product',
              subtitle: 'Upload product images and details.',
              onTap: () {
                context.router.push(const AddProductRoute());
              },
            ),
            const SizedBox(height: 10),
            AdminCard(
              icon: Icons.edit,
              title: 'Manage Products',
              subtitle: 'Edit or delete existing products.',
              onTap: () {
                context.router.push(ManageProductsRoute());
              },
            ),
            const SizedBox(height: 30),

            // Section for User Management
            const Text(
              'User Management',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            AdminCard(
              icon: Icons.people,
              title: 'Manage Users',
              subtitle: 'Change user roles and permissions.',
              onTap: () {
                context.router.push(const UsersManagementRoute());
              },
            ),
          ],
        ),
      ),
    );
  }


}
