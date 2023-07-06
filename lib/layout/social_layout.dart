import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/modules/notifications/notifications_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';


class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){
        if(state is ChangeBottomNavState){
          SocialCubit.get(context)..getProfilePhotos(SocialCubit.get(context).model!.uId!)..getPosts()..getNotifications();
        }
      },
      builder:(context,state){
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 20,
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: const TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
                fontSize: 26,
                fontFamily: 'Times New Roman'
              ),
            ),
            actions: [
              IconButton(
                onPressed: (){
                  cubit.getNotifications();
                  navigateTo(context, const NotificationsScreen());
                },
                icon: const Icon(
                    IconlyBroken.notification,
                )),
              IconButton(
                onPressed: () {
                  signOut(context);
                },
                icon: const Icon(
                  IconlyBroken.logout,
                )),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels:true,
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
                  icon: Icon(IconlyBroken.profile),
                  label: 'Profile'
                ),
              ]
          ),
        );
      },
    );
  }
}
