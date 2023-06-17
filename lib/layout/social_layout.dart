import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/modules/notifications/notifications_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';

import '../modules/add_post/add_post_screen.dart';
import '../shared/cubit/states.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        if(state is SocialNewPostState)
          {
            navigateTo(context,  AddPostScreen());
          }
      },
      builder:(context,state){
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 26,
                fontFamily: 'Times New Roman'
              ),

            ),
            actions: [
              IconButton(
                onPressed: (){
                  navigateTo(context, const NotificationsScreen());
                },
                icon: const Icon(
                    IconlyBroken.notification,
                )),
              IconButton(
                onPressed: ()
                {
                  navigateTo(context, const SearchScreen());
                },
                icon: const Icon(
                  IconlyBroken.search,
                )),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels:false ,
            currentIndex: cubit.currentIndex,
              onTap: (index){
              cubit.changeBottomNav(index);
              },
              items:  const [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(IconlyBroken.home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyBroken.chat),
                  label: 'Chats'
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyBroken.paperUpload),
                  label: 'Add Post'
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyBroken.user3),
                  label: 'Users'
                ),
                BottomNavigationBarItem(
                  icon: Icon(IconlyBroken.setting),
                  label: 'Settings'
                ),
              ]
          ),
        );
      },
    );
  }
}
