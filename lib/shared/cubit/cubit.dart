import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/add_post/add_post_screen.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/cubit/states.dart';

import '../../modules/settings/settings_screen.dart';
import '../components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart'as storage;


class SocialCubit extends Cubit<SocialStates>{
  SocialCubit():super(SocialInitialState());

  static SocialCubit get(context)=>BlocProvider.of(context);

  SocialUserModel? model;
  void getUserData(){
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value){
      model = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error){
      emit(SocialGetUserErrorState(error.toString()));
    });
  }



  int currentIndex = 0 ;

  List<Widget> screens= [
     FeedsScreen(),
    const ChatsScreen(),
    AddPostScreen(),
    const UsersScreen(),
    const SettingsScreen()
  ];

  List<String> titles=[
    'Facebook',
    'Chats',
    'Add Post',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index){
    if (index ==2 ){
      emit(SocialNewPostState());
    }else{
      currentIndex = index;
      emit(ChangeBottomNavState());
    }

  }


  File? profileImage;
  File? coverImage;

  final ImagePicker picker = ImagePicker();

  Future<void> getProfileImage()async{
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if(file!=null){
      profileImage = File(file.path);
      emit(SocialProfileImagePickedSuccessState());
    }else{
      emit(SocialProfileImagePickedErrorState());
    }
  }
  Future<void> getCoverImage()async{
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if(file!=null){
      coverImage = File(file.path);
      emit(SocialCoverImagePickedSuccessState());
    }else{
      emit(SocialCoverImagePickedErrorState());
    }
  }


  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
}){
    emit(SocialUploadProfileImageLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!).then((value){
          value.ref.getDownloadURL()
              .then((value) {
                // emit(SocialUploadProfileImageSuccessState());
                updateUser(
                  name: name,
                  phone: phone,
                  bio: bio,
                  image: value
                );
                profileImage = null;
          }).catchError((error){
            emit(SocialUploadProfileImageErrorState());
          });
        }).catchError((error){
      emit(SocialUploadProfileImageErrorState());
    });
  }


  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
}){
    emit(SocialUploadCoverImageLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!).then((value){
          value.ref.getDownloadURL()
              .then((value) {
                // emit(SocialUploadCoverImageSuccessState());
                updateUser(
                    name: name,
                    phone: phone,
                    bio: bio,
                    cover: value
                );
                coverImage=null;
                //عشان الصورة بعد ما تتحط بروفايل يتغير الايكونز اللي حواليها وترجع كاميرا واقدر احط غيرها
          }).catchError((error){
            emit(SocialUploadCoverImageErrorState());
          });
        }).catchError((error){
      emit(SocialUploadCoverImageErrorState());
    });
  }



  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }){
    SocialUserModel data = SocialUserModel(
      name:name,
      phone:phone,
      bio: bio,
      email: model!.email,
      coverImage: cover??model!.coverImage,
      image: image??model!.image,
      uId: model!.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .update(data.toMap())
        .then((value){
      getUserData();
    }).catchError((error){
      emit(SocialUserUpdateErrorState());
    });

  }



  File? postImage;
  Future<void> getPostImage()async{
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if(file!=null){
      postImage = File(file.path);
      emit(SocialPostImagePickedSuccessState());
    }else{
      emit(SocialPostImagePickedErrorState());
    }
  }
  void removePostImage(){
    postImage = null;
    emit(SocialRemovePostImageState());
  }


  void removePickedProfileImage(){
  profileImage = null;
    emit(SocialRemoveProfileImageState());
  }
  void removePickedCoverImage(){
  coverImage = null;
    emit(SocialRemoveCoverImageState());
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }){
    emit(SocialUploadPostImageLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!).then((value){
      value.ref.getDownloadURL()
          .then((value) {
        createPost(
          text: text,
          dateTime:dateTime,
          postImage: value
        );
      }).catchError((error){
        emit(SocialUploadPostImageSuccessState());
      });
    }).catchError((error){
      emit(SocialUploadPostImageErrorState());
    });
  }




  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }){
    emit(SocialCreatePostLoadingState());
    PostModel data = PostModel(
      image: model!.image,
      name: model!.name,
      uId: model!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage?? '',
    );

    FirebaseFirestore.instance
        .collection('Posts')
        .add(data.toMap())
        .then((value){
          emit(SocialCreatePostSuccessState());
    }).catchError((error){
      emit(SocialCreatePostErrorState());
      print(error.toString());
    });

  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<int>? commentsNumber =[];
  void getPosts(){
    posts = [];
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .get()
        .then((value){
          value.docs.forEach((element) {
            element.reference
            .collection('likes')
            .get()
            .then((value) {
              likes.add(value.docs.length);
              emit(SocialGetLikePostSuccessState());
              postsId.add(element.id);
              posts.add(PostModel.fromJson(element.data()));
            }).catchError((error){
              emit(SocialGetLikePostErrorState(error.toString()));
            });
            element.reference
            .collection('comments')
            .get()
            .then((value) {
              commentsNumber!.add(value.docs.length);
              emit(SocialGetCommentPostSuccessState());
            }).catchError((error){
              emit(SocialGetCommentPostErrorState(error.toString()));
            });
          });

      emit(SocialGetPostSuccessState());
    }).catchError((error){
      emit(SocialGetPostErrorState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('likes')
        .doc(model?.uId)
        .set({
      'like':true,
    })
        .then((value){
          emit(SocialLikePostSuccessState());
    })
        .catchError((error){
          emit(SocialLikePostErrorState(error.toString()));
    });
  }
  void commentPost({required String postId, required commentData}){
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('comments')
        .doc(model?.uId)
        .set({
      'comment':commentData
    }).then((value) {
      emit(SocialCommentPostSuccessState());
    }).catchError((error){
      emit(SocialCommentPostErrorState(error.toString()));
    });

  }
}