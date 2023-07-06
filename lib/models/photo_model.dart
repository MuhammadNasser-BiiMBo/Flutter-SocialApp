class PhotoModel{
  String? dateTime;
  String? photo;

  PhotoModel({
    this.dateTime,
    this.photo
  });

  PhotoModel.fromJson(Map<String,dynamic> json){
    dateTime = json['dateTime'];
    photo = json['photo'];
  }

  Map<String,dynamic> toMap(){
    return {
      'photo':photo,
      'dateTime':dateTime,
    };
  }
}