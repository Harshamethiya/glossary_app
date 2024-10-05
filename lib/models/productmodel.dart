class productmodel{
  String? uid;
  String? itemimage;
  String? itemname;

  productmodel( this.uid, this.itemimage, this.itemname);
  productmodel.fromMap(Map<String,dynamic> map){
  uid=map["uid"];
  itemname=map["itemname"];
  itemimage=map["itemimage"];
  }
  Map<String,dynamic> toMap(){
    return {
      "uid":uid,
      "itemname":itemname,
      "itemimage":itemimage
    };
  }
}