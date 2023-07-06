
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/components/constants.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/network/bloc_observer/bloc_observer.dart';
import 'package:hive/shared/network/cache_helper/cache_helper.dart';
import 'package:hive/shared/network/dio_helper/dio_helper.dart';
import 'package:hive/shared/styles/themes.dart';
import 'layout/social_layout.dart';
import 'modules/login/cubit/cubit.dart';
import 'modules/login/login_screen.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async
{
  // print('on background message ');
  // print(message.data.toString());
  showToast(text: 'on background message ', state: ToastStates.success);

}


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  print(token);
  // دا لو انا بعمل نوتيفيكيشن ونا فاتح الابليكيشن
  FirebaseMessaging.onMessage.listen((event) {
    showToast(text: 'on Message', state: ToastStates.success);
  });
  //دا لو انا بعمل نوتيفيكيشن ونا قافل الابليكيشن
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast(text: 'on Message Opened App', state: ToastStates.success);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;

  uId = CacheHelper.getData(key: 'uId');
  if(uId!= null){
    widget= const SocialLayout();
  }else{
    widget= LoginScreen();
  }

  runApp( MyApp(startWidget:widget));
}

class MyApp extends StatelessWidget
{
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context)=>SocialCubit()..getUserData()..getPosts()..getUsers(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialLoginCubit(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          themeMode: ThemeMode.light,
          home: startWidget
      ),
    );
  }

}
