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

//like Post
class SocialLikePostSuccessState extends SocialStates{}
class SocialLikePostErrorState extends SocialStates{
  final String error;

  SocialLikePostErrorState(this.error);
}
//like Post
class SocialGetLikePostSuccessState extends SocialStates{}
class SocialGetLikePostErrorState extends SocialStates{
  final String error;

  SocialGetLikePostErrorState(this.error);
}
//comment Post
class SocialCommentPostSuccessState extends SocialStates{}
class SocialCommentPostErrorState extends SocialStates{
  final String error;

  SocialCommentPostErrorState(this.error);
}
//get comment Post
class SocialGetCommentPostSuccessState extends SocialStates{}
class SocialGetCommentPostErrorState extends SocialStates{
  final String error;

  SocialGetCommentPostErrorState(this.error);
}
// getAllUsers in chats Screen
class SocialGetAllUsersLoadingState extends SocialStates{}
class SocialGetAllUsersSuccessState extends SocialStates{}
class SocialGetAllUsersErrorState extends SocialStates{
  final String error;

  SocialGetAllUsersErrorState(this.error);

}