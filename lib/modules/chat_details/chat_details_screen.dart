import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;
  ChatDetailsScreen({
    this.userModel
});
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state) {},
      builder:(context,state) => Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userModel!.image!),
              ),
              const SizedBox(width: 15,),
              Text(
                userModel!.name!
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              buildMessage(),
              buildMyMessage(),
              const Spacer(),
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
                              receiverId: userModel!.uId!,
                              text: messageController.text,
                              dateTime: DateFormat.yMMMEd().format(DateTime.now())
                          );
                        },
                        minWidth: 1,
                        child: const Icon(
                          IconlyBroken.send,
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
}
Widget buildMessage()=>Align(
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
    child: const Text(
      'Hello how u doing..?',
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500
      ),
    ),
  ),
);
Widget buildMyMessage()=>Align(
  alignment: AlignmentDirectional.centerEnd,
  child: Container(
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
    child: const Text(
      'Hello how u doing..?',
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500
      ),
    ),
  ),
);