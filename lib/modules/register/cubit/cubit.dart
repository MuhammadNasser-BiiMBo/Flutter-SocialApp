import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

import '../../../shared/network/dio_helper/dio_helper.dart';
import '../../../shared/network/end_points/end_points.dart';


class SocialRegisterCubit extends Cubit<SocialRegisterStates>{
  SocialRegisterCubit():super(SocialRegisterInitialState());

  // SocialLoginModel? registerModel;
  static SocialRegisterCubit get(context) =>BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }){

    emit(SocialRegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value) {
      createUser(
          email: email,
          name: name,
          phone: phone,
          uId: value.user!.uid
      );
      // emit(SocialRegisterSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(SocialRegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String name,
    required String phone,
    required String uId,
}){
    SocialUserModel model = SocialUserModel(
      name:name,
      email:email,
      phone:phone,
      uId:uId,
      bio: 'write your bio ...',
      isEmailVerified: false,
      image:'https://img.freepik.com/free-photo/vegetables-set-left-black-slate_1220-685.jpg?w=1480&t=st=1676054895~exp=1676055495~hmac=2e7283bdb758a46bb103b56bc640a26b772dc2f9dac5b038f0db895c4ac8c09b',
      coverImage:'https://img.freepik.com/free-photo/candid-shot-puzzled-caucasian-male-with-dark-stubble-looks-suspiciously-aside-raises-eyebrows-wears-red-t-shirt-notices-something-blank-space-people-facial-expressions-concept_273609-16310.jpg?w=1380&t=st=1676054176~exp=1676054776~hmac=c26dfc2ca1ce1e7a0a9c07d1f109bee68bb6334b80c6e4e9eed5d3720a4daf8e',
    );

    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessState());
      print(model.name);
      print(model.uId);
      print(model.phone);
      print(model.email);
    }).catchError((error){
      print(error.toString());
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }

  IconData suffix=Icons.visibility_off_outlined;
  bool isPassword = true;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix= isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(SocialChangeVisibilityState());
  }
}