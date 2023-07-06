import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/models/social_user_model.dart';
import 'package:hive/modules/profile/profile_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';


class UserProfileScreen extends StatelessWidget {
  SocialUserModel userModel;
  UserProfileScreen( { required this.userModel, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = userModel;
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: const Text('User Profile'),
              leading: BackButton(
                onPressed: (){
                  Navigator.pop(context);
                  SocialCubit.get(context).getFollowers(userModel);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                      image: NetworkImage('${model.coverImage}'),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          CircleAvatar(
                            radius: 64,
                            backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage('${model.image}'),
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(model.name.toString(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 19,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(model.bio!.isNotEmpty?model.bio!: '',
                        style: Theme.of(context).textTheme.caption),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(SocialCubit.get(context).numberOfUserPosts.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('Posts',
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                          fontSize: 16
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(SocialCubit.get(context).photos.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('Photos',
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontSize: 16
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Text(SocialCubit.get(context).followings.length.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('Followers',
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontSize: 16
                                      )),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialCubit.get(context).followings.contains(SocialCubit.get(context).model) ?
                        OutlinedButton(
                          onPressed: () {
                            FirebaseMessaging.instance.unsubscribeFromTopic('Following-${model.name}').then((value) {
                              showToast(text: 'Successfully unFollowed ${model.name}', state: ToastStates.success);
                            });
                            SocialCubit.get(context).unfollowUser(model);
                            SocialCubit.get(context).unfollowUser(SocialCubit.get(context).model!);

                          },
                          child: Row(
                            children: [
                              const Text('UnFollow'),
                              const SizedBox(width: 3,),
                              Icon(
                                Icons.heart_broken_outlined,
                                color: Colors.red.shade300,
                              )
                            ],
                          ),
                        ) :
                        OutlinedButton(
                          onPressed: () {
                            FirebaseMessaging.instance.subscribeToTopic('Following-${model.name?.replaceAll(' ', '')}').then((value) {
                              showToast(text: 'Successfully Followed ${model.name}', state: ToastStates.success);
                            });
                            SocialCubit.get(context).followUser(model);
                            SocialCubit.get(context).unfollowUser(SocialCubit.get(context).model!);

                          },
                          child: Row(
                            children: [
                              const Text('Follow'),
                              const SizedBox(width: 3,),
                              Icon(
                                IconlyLight.heart,
                                color: Colors.red.shade500,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:  [
                        Text(
                          'Photos',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade700
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        color:  Colors.grey.shade300,
                        height: 1,
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      children: List.generate(SocialCubit.get(context).photos.length, (index) => buildPhotoItem(SocialCubit.get(context).photos[index],context)),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
