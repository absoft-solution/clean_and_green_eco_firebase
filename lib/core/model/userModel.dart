import 'dart:ffi';

class Users {
  String id = "";
  String des = "NA";
  String myPICUrl = "";

//<editor-fold desc="Data Methods">

  Users({
    required this.id,
    required this.des,
    required this.myPICUrl,
  });

  @override
  String toString() {
    return 'Users{' +
        ' id: $id,' +
        ' des: $des,' +
        ' MyPICUrl: $myPICUrl,' +
        '}';
  }

  Users copyWith({
    String? id,
    String? des,
    String? myPICUrl,
  }) {
    return Users(

      id: id ?? this.id,
      des: des ?? this.des,
      myPICUrl: myPICUrl ?? this.myPICUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {

      'id': this.id,
      'des': this.des,
      'myPICUrl': this.myPICUrl,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(

      id: map['id'] as String,
      des: map['des'] as String,
      myPICUrl: map['myPICUrl'] as String,
    );
  }

//</editor-fold>
}












