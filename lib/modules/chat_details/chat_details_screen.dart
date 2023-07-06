import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/models/message_model.dart';
import 'package:hive/models/social_user_model.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:hive/shared/styles/colors.dart';
import 'package:intl/intl.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;
  ChatDetailsScreen({super.key,
   required this.userModel
});
  var messageController = TextEditingController();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {

        SocialCubit.get(context).getMessages(receiverId: userModel.uId!);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 1000), curve: Curves.fastLinearToSlowEaseIn);
        });
        return BlocConsumer<SocialCubit,SocialStates>(
          listener:(context,state) {},
          builder:(context,state) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(userModel.image!),
                  ),
                  const SizedBox(width: 15,),
                  Text(
                    userModel.name!
                  )
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context,index){
                        var message = SocialCubit.get(context).messages[index];
                        if(SocialCubit.get(context).model!.uId==message.senderId){
                          return buildMyMessage(message);
                        }else{
                          return buildMessage(message);
                        }
                      },
                      separatorBuilder: (context,index)=> const SizedBox(
                        height: 10,
                      ),
                      itemCount: SocialCubit.get(context).messages.length,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children:  [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                onFieldSubmitted: (String s){
                                  SocialCubit.get(context).sendMessage(
                                      receiverId: userModel.uId!,
                                      text: messageController.text,
                                      dateTime: DateFormat.yMd().add_Hms().format(DateTime.now())
                                  );
                                  messageController.text ='';
                                },
                                controller: messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your message here ...',
                                ),
                              ),
                            )
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: (){
                              SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId!,
                                  text: messageController.text,
                                  dateTime:  DateFormat.yMd().add_Hms().format(DateTime.now())
                              );
                              messageController.text ='';
                            },
                            minWidth: 1,
                            child: const Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

// a widget that contains the message of the other user
Widget buildMessage(MessageModel message)=>Align(
  alignment: AlignmentDirectional.centerStart,
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(10) ,
          topStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        )
    ),
    child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.text!,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500
          ),
        ),
        Text(
          message.dateTime!.substring(10,15),
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.grey
          ),
        ),
      ],
    ),
  ),
);

// a widget that contains My message
Widget buildMyMessage(MessageModel message)=>Align(
  alignment: AlignmentDirectional.centerEnd,
  child: Container(
    // constraints: BoxConstraints(minWidth: 60),
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
        color: defaultColor.withOpacity(0.4),
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(10) ,
          topStart: Radius.circular(10),
          bottomStart: Radius.circular(10),
        )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          message.text!,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          message.dateTime!.substring(10,15),
          textAlign: TextAlign.right,
          style: const TextStyle(
              fontSize: 12,
              color: Colors.grey
          ),
        ),
      ],
    ),
  ),
);