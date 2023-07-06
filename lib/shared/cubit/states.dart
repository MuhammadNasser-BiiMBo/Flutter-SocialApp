

abstract class SocialStates{

}

class SocialInitialState extends SocialStates{}
class SocialGetUserLoadingState extends SocialStates{}
class SocialGetUserSuccessState extends SocialStates{}
class SocialGetUserErrorState extends SocialStates{
  final String error;

  SocialGetUserErrorState(this.error);

}

class ChangeBottomNavState extends SocialStates{}

class SocialNewPostState extends SocialStates{}
//Profile Pick
class SocialProfileImagePickedSuccessState extends SocialStates{}
class SocialProfileImagePickedErrorState extends SocialStates{}
// Cover Pick
class SocialCoverImagePickedSuccessState extends SocialStates{}
class SocialCoverImagePickedErrorState extends SocialStates{}

//Profile Image  upload

class SocialUploadProfileImageLoadingState extends SocialStates{}
class SocialUploadProfileImageSuccessState extends SocialStates{}
class SocialUploadProfileImageErrorState extends SocialStates{}
//Cover upload
class SocialUploadCoverImageLoadingState extends SocialStates{}
class SocialUploadCoverImageSuccessState extends SocialStates{}
class SocialUploadCoverImageErrorState extends SocialStates{}

//User Update 
class SocialUserUpdateLoadingState extends SocialStates{}
class SocialUserUpdateErrorState extends SocialStates{}

//Create Post
class SocialCreatePostLoadingState extends SocialStates{}
class SocialCreatePostSuccessState extends SocialStates{}
class SocialCreatePostErrorState extends SocialStates{}

//Post Image Picked
class SocialPostImagePickedSuccessState extends SocialStates{}
class SocialPostImagePickedErrorState extends SocialStates{}

//Upload PostImage
class SocialUploadPostImageLoadingState extends SocialStates{}
class SocialUploadPostImageSuccessState extends SocialStates{}
class SocialUploadPostImageErrorState extends SocialStates{}

class SocialRemovePostImageState extends SocialStates{}
class SocialRemoveCoverImageState extends SocialStates{}
class SocialRemoveProfileImageState extends SocialStates{}

//get Post
class SocialGetPostLoadingState extends SocialStates{}
class SocialGetPostSuccessState extends SocialStates{}
class SocialGetPostErrorState extends SocialStates{
  final String error;

  SocialGetPostErrorState(this.error);
}

// delete Post
class SocialDeletePostSuccessState extends SocialStates{}
class SocialDeletePostErrorState extends SocialStates{}
//like Post
class SocialLikePostSuccessState extends SocialStates{}
class SocialUnLikePostSuccessState extends SocialStates{}
class SocialUnLikePostErrorState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final String error;

  SocialLikePostErrorState(this.error);
}
//like Post
class SocialGetPostLikesSuccessState extends SocialStates{}

//comment Post
class SocialCommentPostSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{
  final String error;

  SocialCommentPostErrorState(this.error);
}

//delete comment
class SocialDeletePostCommentSuccessState extends SocialStates{}
class SocialDeletePostCommentErrorState extends SocialStates{
  final String error;

  SocialDeletePostCommentErrorState(this.error);
}

//get comment Post
class SocialGetPostCommentsSuccessState extends SocialStates{}

// getAllUsers in chats Screen
class SocialGetAllUsersLoadingState extends SocialStates{}
class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  final String error;

  SocialGetAllUsersErrorState(this.error);

}

// send, get messages
class SocialSendMessageSuccessState extends SocialStates{}
class SocialSendMessageErrorState extends SocialStates{}
class SocialGetMessagesSuccessState extends SocialStates{}

//add notification
class SocialAddNotificationSuccessState extends SocialStates{}
class SocialAddNotificationErrorState extends SocialStates{}

//Get notification
class SocialGetNotificationSuccessState extends SocialStates{}

//pick photos
class SocialPickPhotoSuccessState extends SocialStates{}
class SocialPickPhotoErrorState extends SocialStates{}
//remove picked Photo
class SocialRemovePickedPhotoSuccessState extends SocialStates{}
// add photo
class SocialUploadPhotoLoadingState extends SocialStates{}
class SocialUploadPhotoSuccessState extends SocialStates{}
class SocialUploadPhotoErrorState extends SocialStates{}
// add photo
class SocialAddPhotoLoadingState extends SocialStates{}
class SocialAddPhotoSuccessState extends SocialStates{}
class SocialAddPhotoErrorState extends SocialStates{}
// change follow widget

class SocialChangeFollowWidgetState extends SocialStates{}

//get number of user Posts
class SocialGetNumberOfUserPostsState extends SocialStates{}

//Follow user
class SocialFollowUserSuccessState extends SocialStates{}
class SocialFollowUserErrorState extends SocialStates{}

//unFollow user
class SocialUnfollowUserSuccessState extends SocialStates{}
class SocialUnfollowUserErrorState extends SocialStates{}


//get Followers
class SocialGetUserFollowersSuccessState extends SocialStates{}
class SocialGetUserFollowersErrorState extends SocialStates{}






