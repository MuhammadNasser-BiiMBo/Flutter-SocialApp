import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state){} ,
      builder: (context,state){
        var model = SocialCubit.get(context).model;
        return Padding(
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
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image:  DecorationImage(
                                  image:NetworkImage('${model!.coverImage}'),
                                  fit: BoxFit.cover
                              )
                          ) ,
                        ),
                      ),
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage('${model.image}'),

                        ),
                      )
                    ],
                  ),
                ),
                Text(
                    model.name.toString(),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 19,
                    )
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    model.bio.toString(),
                    style: Theme.of(context).textTheme.caption
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text(
                                  '100',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text(
                                  '267',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Photos',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text(
                                  '10k',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: (){},
                          child: Column(
                            children: [
                              Text(
                                  '70',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Followings',
                                  style: Theme.of(context).textTheme.caption
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: (){},
                          child: const Text(
                            'Add Photos'
                          ),
                      )
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        onPressed: (){
                          navigateTo(context,  EditProfileScreen());
                        },
                        child: const Icon(
                          IconlyBroken.edit,
                          size: 20,
                        ),
                    )

                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
