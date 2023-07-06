import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/models/social_user_model.dart';
import 'package:hive/modules/users/user_profile_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:hive/shared/styles/colors.dart';


class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var users = SocialCubit.get(context).users;
          return ConditionalBuilder(
            condition: state is! SocialGetAllUsersLoadingState,
            fallback: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ),
            builder: (context) => ListView.separated(

                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildUserItem(users[index], context),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 15,
                ),
                itemCount: users.length),
          );
        });
  }
}
Widget buildUserItem(SocialUserModel user, context) {
  SocialCubit.get(context).getProfilePhotos(user.uId!);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        radius: 50,
        highlightColor: defaultColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          SocialCubit.get(context).getFollowers(user);
          SocialCubit.get(context).getNumberOfUserPost(user.uId!);

          navigateTo(context, UserProfileScreen(userModel: user));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.image!),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    user.bio!.isNotEmpty?user.bio!: '',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}