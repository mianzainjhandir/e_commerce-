import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // 1. User Not Logged In Check
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Favorite", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: const Center(child: Text("Please log in to view Favorite")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Favorite", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('userFavorite')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {

            // 🎯 FIX 1: Handle Connection State (Loading)
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Handle Error (Optional but good practice)
            if (snapshot.hasError) {
              return Center(child: Text("An error occurred: ${snapshot.error}"));
            }

            // Check if data is null (this covers the crash scenario)
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data available."));
            }

            final favoriteDocs = snapshot.data!.docs; // ✅ अब यह सुरक्षित है

            if (favoriteDocs.isEmpty) {
              return const Center(child: Text("No Favorite items yet."));
            }

            // FutureBuilder to fetch details of each item
            return FutureBuilder<List<DocumentSnapshot>>(
                future: Future.wait(
                    favoriteDocs.map((doc) =>
                        FirebaseFirestore.instance.collection('items').doc(doc.id).get()
                    )
                ),
                builder: (context, itemSnapshot) {

                  // 🎯 FIX 2: Handle Connection State (Loading)
                  if (itemSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Handle Error
                  if (itemSnapshot.hasError) {
                    return Center(child: Text("Item fetch error: ${itemSnapshot.error}"));
                  }

                  // Check if data is null
                  if (!itemSnapshot.hasData || itemSnapshot.data == null) {
                    return const Center(child: Text("Item details not found."));
                  }

                  final favoriteItems = itemSnapshot.data!.where((doc) => doc.exists).toList(); // ✅ अब यह सुरक्षित है

                  if (favoriteItems.isEmpty) {
                    return const Center(child: Text("No valid favorite items found."));
                  }

                  return ListView.builder(
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final favoriteItem = favoriteItems[index];

                        // Note: You should check for data field existence before accessing it
                        final itemData = favoriteItem.data() as Map<String, dynamic>?;

                        if(itemData == null){
                          return const SizedBox.shrink(); // Skip if data is corrupted
                        }

                        return GestureDetector(
                          onTap: (){ /* Handle tap */ },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: CachedNetworkImageProvider(itemData['image'] ?? '')
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Text(
                                            itemData['name'] ?? 'N/A',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Text("${itemData['category'] ?? 'Unknown'} Fashion"),
                                        Text(
                                          "\$${itemData['price']?.toStringAsFixed(0) ?? '0'}.00",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.pink,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
            );
          }
      ),
    );
  }
}