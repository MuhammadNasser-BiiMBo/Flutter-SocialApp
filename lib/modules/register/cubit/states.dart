

abstract class SocialRegisterStates{}

class SocialRegisterInitialState extends SocialRegisterStates{}
class SocialRegisterLoadingState extends SocialRegisterStates{}
class SocialRegisterSuccessState extends SocialRegisterStates{
  // final SocialLoginModel registerModel;
  //
  // SocialRegisterSuccessState(this.registerModel);
}
class SocialRegisterErrorState extends SocialRegisterStates{
  final String error;
  SocialRegisterErrorState(this.error);
}class SocialCreateUserSuccessState extends SocialRegisterStates{
  // final SocialLoginModel registerModel;
  //
  // SocialRegisterSuccessState(this.registerModel);
}
class SocialCreateUserErrorState extends SocialRegisterStates{
  final String error;
  SocialCreateUserErrorState(this.error);
}
class SocialChangeVisibilityState extends SocialRegisterStates{}