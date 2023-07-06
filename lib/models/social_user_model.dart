class SocialUserModel{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? coverImage;
  String? bio;
  bool? isEmailVerified;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SocialUserModel &&
              runtimeType == other.runtimeType &&
              image == other.image &&
              bio == other.bio &&
              coverImage == other.coverImage &&
              email == other.email &&
              isEmailVerified == other.isEmailVerified &&
              name == other.name &&
              phone == other.phone &&
              uId == other.uId;

  @override
  int get hashCode =>
      image.hashCode ^
      bio.hashCode ^
      coverImage.hashCode ^
      email.hashCode ^
      isEmailVerified.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      uId.hashCode;

  SocialUserModel({
    this.email,
    this.name,
    this.phone,
    this.image,
    this.coverImage,
    this.uId,
    this.bio,
    this.isEmailVerified
});

  SocialUserModel.fromJson(Map<String,dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'image':image,
      'coverImage':coverImage,
      'bio':bio,
      'isEmailVerified':isEmailVerified
    };
  }
}