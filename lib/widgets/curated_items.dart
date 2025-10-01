
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explorer/core/common/provider/favourite_provider.dart';
import 'package:explorer/view/role_based_login/user/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CuratedItems extends ConsumerWidget {
  final DocumentSnapshot<Object?> eCommerceItems;
  final Size size;
  const CuratedItems({super.key,required this.eCommerceItems,required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(favoriteProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: eCommerceItems.id,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(eCommerceItems['image']))
            ),
            height: size.height*0.25,
            width: size.width*0.5,
            child: Padding(padding: EdgeInsets.all(12),
            child: Align(alignment: Alignment.topRight,child: CircleAvatar(
              radius: 18,
              backgroundColor: provider.isExist(eCommerceItems)? Colors.white: Colors.black,
              child: GestureDetector(
                onTap: (){
                  ref.read(favoriteProvider).toggleFavorite(eCommerceItems);
                },
                child: Icon(
                  provider.isExist(eCommerceItems)?Icons.favorite :
                  Icons.favorite_border,

                  color: provider.isExist(eCommerceItems)?Colors.red :
                  Colors.white,),
              ),
            ),),
            ),
          ),
        ),
        Gap(7),
        Row(
          children: [
            Text("H&M",
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black26),),
            Gap(5),
            Icon(Icons.star,
            color: Colors.amber,
              size: 17,
            ),
            Text("${Random().nextInt(2)+3}.${Random().nextInt(5)+4}"),
            Text("(${Random().nextInt(300)+25})",style: TextStyle(
              color: Colors.black26,
            ),),

          ],
        ),
        SizedBox(
          width: size.width*0.5,
          child: Text(
            maxLines: 1,overflow: TextOverflow.ellipsis,
            eCommerceItems['name']??"N/A",
            style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.5,
          ),),
        ),
        Row(
          children: [
            Text("\$${(eCommerceItems['price']*(1-eCommerceItems['discountPercentage']/100)).toStringAsFixed(2)}",style: TextStyle(
              fontSize: 18,
              color: Colors.pink,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),),
            SizedBox(width: 5,),
            if(eCommerceItems['isDiscounted'] == true)
              Text("\$${eCommerceItems['price'] + 255}.00",style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black26
              ),)
          ],
        ),
      ],
    );
  }
}
