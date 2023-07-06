import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/models/notification_model.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:hive/shared/styles/colors.dart';
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var notifications = SocialCubit.get(context).notifications;
          FirebaseMessaging.onMessage.listen((event) {
            SocialCubit.get(context).addNotifications(event);
            showToast(text: 'on Message', state: ToastStates.success);
          });
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Notifications'
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! SocialGetAllUsersLoadingState,
              fallback: (BuildContext context) => const Center(
                child: CircularProgressIndicator(),
              ),
              builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildNotificationItem(notifications[index], context),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 15,
                  ),
                  itemCount: notifications.length),
            ),
          );
        });
  }
}
Widget buildNotificationItem(NotificationModel notification, context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15.0),
  child: Container(
    decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Colors.grey
        ),
        borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsetsDirectional.only(end: 10),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Icon(
                Icons.notifications_active_outlined,
                color: defaultColor,
                size: 35,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
              flex: 1,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.sender!,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    notification.text!,
                    style:  TextStyle(
                      overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        color: defaultColor.shade700
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        notification.dateTime!.substring(0,16),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
