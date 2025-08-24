// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

@RoutePage()
class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final Stream<QuerySnapshot> _productsStream =
  FirebaseFirestore.instance.collection('products').snapshots();

  Future<void> _deleteProduct(String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully!')),
        );
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products',style: TextStyle(
            color: Colors.white,
            fontFamily: "Urbanist",
            fontSize: 24
        )),
        backgroundColor: MyColors.kPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found.',style: TextStyle(
                color: MyColors.kPrimaryColor,
                fontFamily: "Urbanist",
                fontSize: 24
            )));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productDoc = snapshot.data!.docs[index];
              final productData = productDoc.data()! as Map<String, dynamic>;
              final productId = productDoc.id;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: productData['imageUrl'] != null
                      ? CachedNetworkImage(
                    imageUrl: productData['imageUrl'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  )
                      : const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(Icons.image_not_supported)),
                  title: Text(
                    productData['name'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '\$${productData['price']?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteProduct(productId),
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
