import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/services/database.dart';





class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});






  @override
  Widget build(BuildContext context) {
    bool isFavorite = false;
final user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user == null) {
      return Center(child: Text("Please log in."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Favorites"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseMethods().getFavorites(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final favDocs = snapshot.data!.docs;

          if (favDocs.isEmpty) return Center(child: Text("No favorites yet."));

          return ListView.builder(
            itemCount: favDocs.length,
            itemBuilder: (context, index) {
              final data = favDocs[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: Image.network(data['imageUrl'] ?? ""),
                title: Text(data['title'] ?? ""),
                subtitle: Text(data['description'] ?? ""),
              );
            },
          );
        },
      ),
    );
  }
}
