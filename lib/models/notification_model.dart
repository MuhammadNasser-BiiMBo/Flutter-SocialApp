class NotificationModel{
  String? sender;
  String? dateTime;
  String? text;

  NotificationModel({
    this.dateTime,
    this.sender,
    this.text
  });
  NotificationModel.fromJson(Map<String,dynamic> json){
    dateTime=json['dateTime'];
    sender=json['sender'];
    text=json['text'];
  }
  Map<String,dynamic> toMap(){
    return{
      'dateTime':dateTime,
      'sender':sender,
      'text':text,
    };

  }
}