class LikeModel{
  String? name;
  String? uId;
  String? image;

  LikeModel({
    this.name,
    this.image,
    this.uId,
  });

  LikeModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'uId':uId,
      'image':image,
    };
  }
}