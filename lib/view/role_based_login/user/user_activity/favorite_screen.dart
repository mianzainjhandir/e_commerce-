import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/core/common/provider/favourite_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  // // Function to handle the delete operation
  // Future<void> _deleteFavoriteItem(String favoriteDocId) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('userFavorite').doc(favoriteDocId).delete();
  //     // Optionally show a successful deletion message (e.g., using SnackBar)
  //     print("Item $favoriteDocId deleted from favorites.");
  //   } catch (e) {
  //     print("Error deleting favorite item: $e");
  //     // Optionally show an error message
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final provider = ref.watch(favoriteProvider);
    // 1. User Not Logged In Check
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Favorite", style: TextStyle(fontWeight: FontWeight.bold)),
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
        // This stream fetches the documents from 'userFavorite' where 'userId' matches.
        // The ID of these documents (doc.id) is being used as the ID for the actual 'items'.
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

            // Check if data is null
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data available."));
            }

            final favoriteDocs = snapshot.data!.docs; // This list contains the favorite documents (including their IDs for deletion)

            if (favoriteDocs.isEmpty) {
              return const Center(child: Text("No Favorite items yet."));
            }

            // FutureBuilder to fetch details of each item based on the ID from the favoriteDocs
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

                  final favoriteItems = itemSnapshot.data!.where((doc) => doc.exists).toList();

                  if (favoriteItems.isEmpty) {
                    return const Center(child: Text("No valid favorite items found."));
                  }

                  return ListView.builder(
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        final favoriteItem = favoriteItems[index];

                        // Get the ID of the document in 'userFavorite' to be used for deletion
                        final favoriteDocId = favoriteDocs[index].id;

                        final itemData = favoriteItem.data() as Map<String, dynamic>?;

                        if(itemData == null){
                          return const SizedBox.shrink(); // Skip if data is corrupted
                        }

                        // CORRECTED STRUCTURE: Use Stack to overlay the main content and the Positioned delete button.
                        return Stack(
                          children: [
                            // 1. Main Content (The existing padded container, wrapped in GestureDetector)
                            GestureDetector(
                              onTap: (){ /* Handle tap to view item details */ },
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
                            ),
                            // 2. Delete Button (Positioned inside the Stack)
                            Positioned(
                              top: 25, // Positioning the delete button relative to the Stack
                              right: 25,
                              child: GestureDetector(
                                onTap: (){
                                  provider.toggleFavorite(favoriteItem);

                                  // _deleteFavoriteItem(favoriteDocId);
                                },
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.delete, color: Colors.red, size: 20),
                                ),
                              ),
                            ),
                          ],
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
