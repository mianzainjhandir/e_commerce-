
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
   const FavoriteScreen({super.key});

   @override
   Widget build(BuildContext context) {
     final userId = FirebaseAuth.instance.currentUser!.uid;
     return Scaffold(

       backgroundColor: Colors.white,
       appBar: AppBar(
         centerTitle: true,
         title: Text("Favorite",
         style: TextStyle(
           fontWeight: FontWeight.bold
         ),
         ),
       ),
       body: userId == null ? Center(child: Text("Please log in to view Favorite"))
           : StreamBuilder(
           stream: FirebaseFirestore.instance.collection('userFavorite')
               .where('userId',isEqualTo: userId)
               .snapshots(),
           builder: (context, snapshot){
             if(snapshot.hasData){
               return Center(child: CircularProgressIndicator(),);
             }
             final favoriteDocs = snapshot.data!.docs;
             if(favoriteDocs.isEmpty){
               return Center(child: Text("No Favorite yet"),);
             }
             return FutureBuilder(future: future, builder: builder)
           }
       )
     );
   }
 }




