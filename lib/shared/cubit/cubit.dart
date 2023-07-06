import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/models/comment_model.dart';
import 'package:hive/models/like_model.dart';
import 'package:hive/models/message_model.dart';
import 'package:hive/models/notification_model.dart';
import 'package:hive/models/photo_model.dart';
import 'package:hive/models/post_model.dart';
import 'package:hive/models/social_user_model.dart';
import 'package:hive/modules/add_post/add_post_screen.dart';
import 'package:hive/modules/chats/chats_screen.dart';
import 'package:hive/modules/feeds/feeds_screen.dart';
import 'package:hive/modules/profile/profile_screen.dart';
import 'package:hive/modules/users/users_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/components/constants.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? model;
  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(uId).get().then((value) {
      model = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    AddPostScreen(),
    const UsersScreen(),
    const ProfileScreen()
  ];

  List<String> titles = [
    'Hive',
    'Chats',
    'Add Post',
    'Users',
    'Profile',
  ];

  void changeBottomNav(int index) {
    if (index == 1 || index == 3) {
      getUsers();
    }
    if (index == 4) {
      getNumberOfUserPost(model!.uId!);
      getFollowers(model!);
    }
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  File? profileImage;
  File? coverImage;

  final ImagePicker picker = ImagePicker();

  Future<void> getProfileImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      profileImage = File(file.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      coverImage = File(file.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      emit(SocialCoverImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUploadProfileImageLoadingState());
    if (profileImage!.lengthSync() > 1048576) {
      emit(SocialUploadProfileImageErrorState());
      showToast(
          text: 'Profile Image size Exceeds Limits', state: ToastStates.error);
      removePickedProfileImage();
      return;
    }
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadProfileImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, image: value);
        profileImage = null;
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    if (coverImage!.lengthSync() > 1048576) {
      emit(SocialUploadCoverImageErrorState());
      showToast(
          text: 'Cover Image size Exceeds Limits', state: ToastStates.error);
      removePickedCoverImage();
      return;
    }
    emit(SocialUploadCoverImageLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(SocialUploadCoverImageSuccessState());
        updateUser(name: name, phone: phone, bio: bio, cover: value);
        coverImage = null;
        //عشان الصورة بعد ما تتحط بروفايل يتغير الايكونز اللي حواليها وترجع كاميرا واقدر احط غيرها
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  }) {
    SocialUserModel data = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: model!.email,
      coverImage: cover ?? model!.coverImage,
      image: image ?? model!.image,
      uId: model!.uId,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .update(data.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      postImage = File(file.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void removePickedProfileImage() {
    profileImage = null;
    emit(SocialRemoveProfileImageState());
  }

  void removePickedCoverImage() {
    coverImage = null;
    emit(SocialRemoveCoverImageState());
  }

  void uploadPostImage({
    String? text,
    required String dateTime,
  }) {
    if (postImage!.lengthSync() > 1048576) {
      emit(SocialUploadPostImageErrorState());
      showToast(
          text: 'Post Image size Exceeds Limits', state: ToastStates.error);
      removePostImage();
      return;
    }
    emit(SocialUploadPostImageLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(text: text ?? '', dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(SocialUploadPostImageSuccessState());
      });
    }).catchError((error) {
      emit(SocialUploadPostImageErrorState());
    });
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel data = PostModel(
      image: model!.image,
      name: model!.name,
      uId: model!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('Posts')
        .add(data.toMap())
        .then((value) {
      value.collection('Likes').get();
      getPosts();
      emit(SocialCreatePostSuccessState());
      getNumberOfUserPost(model!.uId!);
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  Future<void> deletePost(String date, String postOwnerUId) async {
    if (model!.uId == postOwnerUId) {
      FirebaseFirestore.instance
          .collection('Posts')
          .where('dateTime', isEqualTo: date)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.collection('Likes').get().then((value) {
            for (var element in value.docs) {
              element.reference.delete();
            }
          });
          element.reference.collection('Comments').get().then((value) {
            for (var element in value.docs) {
              element.reference.delete();
            }
          });
          element.reference.delete();
        });
        getPosts();
        emit(SocialDeletePostSuccessState());
        getNumberOfUserPost(model!.uId!);
      });
    } else {
      emit(SocialDeletePostErrorState());
      return;
    }
  }

  // contains all posts in the feeds screen
  List<PostModel> posts = [];
  //All users you can chat with
  List<SocialUserModel> users = [];
  //ID for each post to control for likes and comments
  List<String> postsId = [];
  //contains number of likes in each post and posts are indexed
  List<int> likesNumber = [];
  //contains number of comments in each post and posts are indexed
  List<int> commentsNumber = [];

  List<bool> isLike = [];
  List<List<LikeModel>> allLikes = [];
  // to get Posts in the Feeds Screen
  void getPosts() async {
    allLikes = [];
    posts = [];
    isLike = [];
    comments = [];
    likes = [];
    likesNumber = [];
    commentsNumber = [];
    emit(SocialGetPostLoadingState());
    FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('dateTime')
        .get()
        .then((value) async {
      for (var element in value.docs) {
        var commentSnapshot =
        await element.reference.collection('Comments').get();
        var likeSnapshot = await element.reference.collection('Likes').get();
        var myLikesSnapshot = await element.reference
            .collection('Likes')
            .where('uId', isEqualTo: model!.uId)
            .get();
        comments = [];
        likes = [];
        for (var m in commentSnapshot.docs) {
          comments.add(CommentModel.fromJson(m.data()));
          print('Comments Length :${comments.length}');
        }
        commentsNumber.add(comments.length);
        for (var n in likeSnapshot.docs) {
          likes.add(LikeModel.fromJson(n.data()));
          print('Likes Length :${likes.length}');
        }
        likesNumber.add(likes.length);
        // Find the index of the post in the allLikes list
        int postIndex = posts.indexOf(PostModel.fromJson(element.data()));

        // Update or add the likes list of the post in the allLikes list
        if (postIndex != -1) {
          allLikes[postIndex] = likes;
        } else {
          allLikes.add(likes);
        }
        print(likesNumber);
        if (myLikesSnapshot.docs.isNotEmpty) {
          isLike.add(true);
        } else {
          isLike.add(false);
        }
        if (element.get('uId') == model!.uId &&
            element.get('image') != model!.image) {
          element.reference.update(model!.toMap());
        }
        postsId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }
      print('all likes Length:${allLikes.length}');
      for (int i = isLike.length; i < allLikes.length; i++) {
        isLike.add(false);
      }
      emit(SocialGetPostSuccessState());
    });
  }

  // to like a post
  void likePost(String postId, index) {
    LikeModel likeModel =
    LikeModel(uId: model!.uId, name: model!.name, image: model!.image);
    FirebaseFirestore.instance
        .collection('Posts').get().then((value) {
       for (var element in value.docs) {
         if(element.id==postId){
           element.reference.collection('Likes').add(likeModel.toMap()).then((value) {
               likesNumber[index]++;
               likes.add(likeModel);
               isLike[index] = true;
               // getPosts();
               emit(SocialLikePostSuccessState());
               // print(index);
           }).catchError((error) {
               emit(SocialLikePostErrorState(error.toString()));
             });
         }
       }});
  }

  void unLikePost(String postId, index) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .where('uId', isEqualTo: model!.uId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
      likesNumber[index]--;
      isLike[index] = false;
      emit(SocialUnLikePostSuccessState());
    }).catchError((error) {
      emit(SocialUnLikePostErrorState());
    });
  }

  // to comment a Post
  void commentPost(String postId, String text, String dateTime, int index) {
    CommentModel commentModel = CommentModel(
      uId: model!.uId,
      name: model!.name,
      image: model!.image,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .add(commentModel.toMap())
        .then((value) {
      // getPostComments(postId, index);
      emit(SocialCommentPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  void deletePostComment(String postId, int index, int commIndex) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .where('dateTime', isEqualTo: comments[commIndex].dateTime)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
      emit(SocialDeletePostCommentSuccessState());
    }).catchError((error) {
      emit(SocialDeletePostCommentErrorState(error.toString()));
    });
  }

  List<CommentModel> comments = [];
  List<LikeModel> likes = [];

  void getPostComments(String postId, int index) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      comments = [];
      // commentsNumber[index]=value.docs.length;
      for (var element in value.docs) {
        comments.add(CommentModel.fromJson(element.data()));
        // commentsNumber[index]++;
      }
      emit(SocialGetPostCommentsSuccessState());
    });
  }

  void getPostLikes(String postId, index) {
    FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .collection('Likes')
        .orderBy('dateTime')
        .snapshots()
        .listen((value) {
      likes = [];
      // likesNumber[index]=value.docs.length;
      for (var element in value.docs) {
        likes.add(LikeModel.fromJson(element.data()));
      }
      emit(SocialGetPostLikesSuccessState());
    });
  }

  //Method to get All users Available to chat with
  void getUsers() {
    emit(SocialGetAllUsersLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != model!.uId) {
            users.add(SocialUserModel.fromJson(element.data()));
          }
        }
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
      });
    }
  }

  // Method to send Message to a user
  void sendMessage(
      {required String receiverId,
        required String text,
        required String dateTime}) {
    MessageModel message = MessageModel(
        senderId: model!.uId,
        text: text,
        dateTime: dateTime,
        receiverId: receiverId);
    //set my chats
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .add(message.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    //set receiver chats
    FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverId)
        .collection('Chats')
        .doc(model!.uId)
        .collection('Messages')
        .add(message.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  // a list that contains All messages in a chat
  List<MessageModel> messages = [];
  //the method to get chat Messages
  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .collection('Chats')
        .doc(receiverId)
        .collection('Messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(SocialGetMessagesSuccessState());
    });
  }

  List<NotificationModel> notifications = [];
  void addNotifications(RemoteMessage message) {
    NotificationModel notificationModel = NotificationModel(
        dateTime: message.sentTime.toString(),
        text: message.data['type'],
        sender: message.from!.substring(18));
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .collection('Notifications')
        .add(notificationModel.toMap())
        .then((value) {
      emit(SocialAddNotificationSuccessState());
    }).catchError((error) {
      emit(SocialAddNotificationErrorState());
    });
  }

  void getNotifications() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .collection('Notifications')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      notifications = [];
      List<String> uniqueDateTimes = [];
      for (var element in event.docs) {
        var notification = NotificationModel.fromJson(element.data());
        if (!uniqueDateTimes.contains(notification.dateTime)) {
          notifications.add(notification);
          uniqueDateTimes.add(notification.dateTime!);
        }
      }
    });
    emit(SocialGetNotificationSuccessState());
  }

  File? pickedPhoto;
  Future<void> pickProfilePhoto() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      pickedPhoto = File(file.path);
      emit(SocialPickPhotoSuccessState());
    } else {
      emit(SocialPickPhotoErrorState());
    }
  }

  void removePickedProfilePhoto() {
    pickedPhoto = null;
    emit(SocialRemovePickedPhotoSuccessState());
  }

  void uploadProfilePhoto({required String dateTime}) {
    emit(SocialUploadPhotoLoadingState());
    storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(pickedPhoto!.path).pathSegments.last}')
        .putFile(pickedPhoto!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        addProfilePhoto(dateTime: dateTime, photo: value);
      });
      emit(SocialUploadPhotoSuccessState());
    }).catchError((error) {
      emit(SocialUploadPhotoErrorState());
    });
  }

  void addProfilePhoto({required String dateTime, required String photo}) {
    emit(SocialAddPhotoLoadingState());
    PhotoModel photoModel = PhotoModel(dateTime: dateTime, photo: photo);
    FirebaseFirestore.instance
        .collection('Users')
        .doc(model!.uId)
        .collection('Photos')
        .add(photoModel.toMap())
        .then((value) {
      emit(SocialAddPhotoSuccessState());
    }).catchError((error) {
      emit(SocialAddPhotoErrorState());
    });
  }

  List<PhotoModel> photos = [];
  void getProfilePhotos(String uId) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .collection('Photos')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      photos = [];
      for (var element in event.docs) {
        photos.add(PhotoModel.fromJson(element.data()));
      }
    });
  }

  void followUser(SocialUserModel user) {
    SocialUserModel followedUser = SocialUserModel(
      image: user.image,
      bio: user.bio,
      coverImage: user.coverImage,
      email: user.email,
      isEmailVerified: user.isEmailVerified,
      name: user.name,
      phone: user.phone,
      uId: user.uId,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(followedUser.uId)
        .collection('Followers')
        .add(model!.toMap())
        .then((value) {
      getFollowers(user);
      emit(SocialFollowUserSuccessState());
    }).catchError((error) {
      emit(SocialFollowUserErrorState());
    });
  }

  void unfollowUser(SocialUserModel user) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uId)
        .collection('Followers')
        .where('uId', isEqualTo: model!.uId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.delete();
      }
      getFollowers(user);
      emit(SocialUnfollowUserSuccessState());
    }).catchError((error) {
      emit(SocialUnfollowUserErrorState());
    });
  }

  List<SocialUserModel> followings = [];

  void getFollowers(SocialUserModel user) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uId)
        .collection('Followers')
        .get()
        .then((value) {
      followings = [];
      for (var element in value.docs) {
        followings.add(SocialUserModel.fromJson(element.data()));
      }
      emit(SocialGetUserFollowersSuccessState());
    }).catchError((error) {
      emit(SocialGetUserFollowersErrorState());
    });
  }

  int numberOfUserPosts = 0;
  void getNumberOfUserPost(String uId) {
    numberOfUserPosts = 0;
    for (var post in posts) {
      if (post.uId == uId) {
        numberOfUserPosts = numberOfUserPosts + 1;
      }
    }
    emit(SocialGetNumberOfUserPostsState());
  }
}
