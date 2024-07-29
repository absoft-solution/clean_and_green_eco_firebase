

import 'dart:ui';

class PostCreatedModel{
   String? description;
   Image? image;

   PostCreatedModel(this.description, this.image);


   Map<String ,dynamic> toMap(){
     Map<String,dynamic>map={
       'description':description,
       'image':image,
     };
     return map;
   }
}