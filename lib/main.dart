import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/network/bloc_observer/bloc_observer.dart';
import 'package:social_app/shared/network/cache_helper/cache_helper.dart';
import 'package:social_app/shared/network/dio_helper/dio_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

import 'modules/login/cubit/cubit.dart';
import 'modules/login/login_screen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  // bool isDark = CacheHelper.getData(key: 'isDark');
  Widget widget;
  // late bool? onBoarding =CacheHelper.getData(key: 'onBoarding');
  // token = CacheHelper.getData(key: 'token');
  uId = CacheHelper.getData(key: 'uId');
  if(uId!= null){
    widget= SocialLayout();
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
          create: (BuildContext context)=>SocialCubit()..getUserData()..getPosts(),
        ),
        BlocProvider(
          create: (BuildContext context) => SocialLoginCubit(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.light,
          home: startWidget
      ),
    );
  }

}
