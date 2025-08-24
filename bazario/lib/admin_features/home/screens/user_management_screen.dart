// dart format width=80
import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_route/annotations.dart';

@RoutePage()
class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  // A stream to listen for changes in the 'users' collection in real-time
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('users').snapshots();

  // Method to toggle the 'isAdmin' flag for a specific user
  Future<void> _toggleAdminStatus(String userId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isAdmin': !currentStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'User status updated successfully!',
          ),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user status: ${e.message}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users',style: TextStyle(
            color: Colors.white,
            fontFamily: "Urbanist",
            fontSize: 24
        )),
        backgroundColor: MyColors.kPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found in the database.',style: TextStyle(
              color: MyColors.kPrimaryColor,
                  fontFamily: "Urbanist",
                  fontSize: 24
              )),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final userDoc = snapshot.data!.docs[index];
              final userData = userDoc.data()! as Map<String, dynamic>;
              final userId = userDoc.id;
              final bool isAdmin = userData['isAdmin'] ?? false;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    userData['username'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: "Urbanist",fontSize: 16),
                  ),
                  subtitle: Text(userData['email'] ?? 'No Email'),
                  trailing: ElevatedButton(
                    onPressed: () => _toggleAdminStatus(userId, isAdmin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAdmin ? Colors.green : Colors.grey[400],
                    ),
                    child: Text(
                      isAdmin ? 'Is Admin' : 'Make Admin',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
