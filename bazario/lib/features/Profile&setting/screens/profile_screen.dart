// dart format width=80
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/app_router.gr.dart';
import '../../../utils/constants/colors.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Account Section
            const Text(
              'My Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildProfileInfoCard(context),
            const SizedBox(height: 30),

            // Settings Section
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildSettingsList(context),
            const SizedBox(height: 30),

            // Help & Support Section
            const Text(
              'Help & Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildHelpList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/user_avatar.png'),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ali ahmed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'aliamed@gmail.com',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Column(
        children: [
          _buildListTile(context, Icons.person_outline, 'Edit Profile'),
          const Divider(),
          _buildListTile(context, Icons.lock_outline, 'Change Password'),
          const Divider(),
          _buildListTile(context, Icons.notifications_none, 'Notifications'),
          const Divider(),
          _buildListTile(context, Icons.language, 'Language'),
          const Divider(),
          _buildListTile(context, Icons.shopping_bag_outlined, 'Orders')
        ],
      ),
    );
  }

  Widget _buildHelpList(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Column(
        children: [
          _buildListTile(context, Icons.help_outline, 'FAQ'),
          const Divider(),
          _buildListTile(context, Icons.info_outline, 'About Us'),
          const Divider(),
          _buildListTile(context, Icons.logout, 'Log out',
              color: MyColors.kPrimaryColor),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title, style: TextStyle(color: color ?? Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        switch (title) {
          case 'Orders':
            context.router.push(const MyOrdersRoute()); // Note the use of `const`
            break;
        // Add other cases here as needed
        // case 'Profile':
        //   context.router.push(const ProfileRoute());
        //   break;
          default:
          // Handle the case where the title doesn't match any route
            print('Route not found for title: $title');
            break;
        }
      },
    );
  }
}