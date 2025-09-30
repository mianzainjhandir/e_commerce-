import 'package:explorer/core/common/utils/color_conversation.dart';
import 'package:flutter/material.dart';

class SizeAndColor extends StatefulWidget {
  final List<dynamic> colors;
  final List<dynamic> sizes;
  final Function(int) onColorSelected;
  final Function(int) onSizeSelected;
  final int selectedColorIndex;
  final int selectedSizeIndex;


  const SizeAndColor({super.key,
    required this.colors,
    required this.sizes,
    required this.onColorSelected,
    required this.onSizeSelected,
    required this.selectedColorIndex,
    required this.selectedSizeIndex,
  });

  @override
  State<SizeAndColor> createState() => _SizeAndColorState();
}

class _SizeAndColorState extends State<SizeAndColor> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(width: size.width / 2.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Color",style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),),
              SingleChildScrollView(
                child: Row(
                  children: widget.colors.asMap().entries.map<Widget>((entry){
                    final int index = entry.key;
                    final color = entry.value;

                    return Padding(padding: EdgeInsets.only(top: 10,right: 10),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: getColorFromName(color),
                        child: GestureDetector(
                          onTap: () {
                            widget.onColorSelected(index);
                          },
                          child: Icon(Icons.check,
                            color: widget.selectedColorIndex == index ?
                            Colors.white: Colors.transparent,),
                        ),
                      ),
                    );

                  }).toList(),
                ),
              )
            ],
          ),
        ),
        SizedBox(width: size.width / 2.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Size",style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),),
              SingleChildScrollView(
                child: Row(
                  children:widget.sizes.asMap().entries.map<Widget>((entry){
                    final int index = entry.key;
                    final size = entry.value;

                    return GestureDetector(
                      onTap: (){
                       widget.onSizeSelected(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10,top: 10),
                        height: 35,width: 35,decoration: BoxDecoration(
                        shape: BoxShape.circle,color: widget.selectedSizeIndex == index?
                      Colors.black: Colors.white,
                        border: Border.all(color: widget.selectedSizeIndex == index ? Colors.black: Colors.black12
                        ),
                      ),
                        child: Center(
                          child: Text(size,style: TextStyle(
                              fontWeight: FontWeight.bold ,
                              color: widget.selectedSizeIndex == index?
                              Colors.white:Colors.black
                          ),),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
