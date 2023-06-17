import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder:(context,state){
        var users = SocialCubit.get(context).users;
        return ConditionalBuilder(
          condition: state is !SocialGetAllUsersLoadingState,
          fallback: (BuildContext context) =>const Center(child: CircularProgressIndicator(),),
          builder:(context)=> ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context,index)=> buildChatItem(users[index]),
            separatorBuilder: (context , index)=> mySeparator(),
            itemCount: users.length),

        );
      }
    ) ;
  }
}
Widget buildChatItem(SocialUserModel user)=>InkWell(
  onTap: (){},
  child:Padding(
    padding: const EdgeInsets.all(15.0),
    child:   Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(user.image!),
        ),
        const SizedBox(width:  20,),
        Text(
          user.name!,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ],
    ),
  ),
);