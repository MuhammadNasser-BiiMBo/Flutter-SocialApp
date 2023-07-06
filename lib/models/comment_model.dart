class CommentModel{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? text;

  CommentModel({
    this.name,
    this.image,
    this.uId,
    this.dateTime,
    this.text,
  });

  CommentModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    uId = json['uId'];
    dateTime = json['dateTime'];
    image = json['image'];
    text = json['text'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'text':text,
      'dateTime':dateTime,
    };
  }
}