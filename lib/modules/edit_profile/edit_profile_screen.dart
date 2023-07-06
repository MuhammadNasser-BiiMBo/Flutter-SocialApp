import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';


class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context, state ){},
      builder: (context, state ){
        var model = SocialCubit.get(context).model;
        var profileImage =SocialCubit.get(context).profileImage;
        var coverImage =SocialCubit.get(context).coverImage;
        nameController.text=model!.name!;
        bioController.text=model.bio!.isEmpty?'Enter your bio Here ...': model.bio!;
        phoneController.text=model.phone!;
        return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
              leading: IconButton(
                onPressed: (){
                Navigator.pop(context);
                },
                  icon: const Icon(
                  IconlyBroken.arrowLeft2
              )),
              actions: [
                defaultTextButton(function: (){
                  SocialCubit.get(context).updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                  );
                }, text: 'UPDATE'),
                const SizedBox(width: 10,)
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if(state is SocialUserUpdateLoadingState)
                      const LinearProgressIndicator(),
                    if(state is SocialUserUpdateLoadingState)
                      const SizedBox(height: 15,),
                    SizedBox(
                      height: 225,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: coverImage ==null?Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                coverImage==null?
                                  Container(
                                  height: 180,
                                  decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image:  DecorationImage(
                                          image:NetworkImage('${model.coverImage}'),
                                          fit: BoxFit.cover
                                      )
                                  ) ,
                                ):
                                Container(
                                  height: 180,
                                  decoration:BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image:  DecorationImage(
                                          image:FileImage(coverImage),
                                          fit: BoxFit.cover
                                      )
                                  ) ,
                                ),
                                IconButton(
                                     onPressed: (){
                                       SocialCubit.get(context).getCoverImage();
                                     },
                                     icon: const CircleAvatar(
                                       child: Icon(
                                           IconlyBroken.camera,
                                         size: 22,
                                       ),
                                     ),
                                 )
                              ],
                            ):Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          coverImage==null?
                          Container(
                            height: 180,
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image:  DecorationImage(
                                    image:NetworkImage('${model.coverImage}'),
                                    fit: BoxFit.cover
                                )
                            ) ,
                          ):
                          Container(
                            height: 180,
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image:  DecorationImage(
                                    image:FileImage(coverImage),
                                    fit: BoxFit.cover
                                )
                            ) ,
                          ),
                          IconButton(
                            onPressed: (){
                              SocialCubit.get(context).removePickedCoverImage();
                            },
                            icon: const CircleAvatar(
                              child: Icon(
                                Icons.close,
                                size: 22,
                              ),
                            ),
                          )
                        ],
                      ),
                          ),
                          profileImage==null?
                            Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: profileImage==null?
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage('${model.image}'),
                                ):CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(profileImage),

                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: const CircleAvatar(
                                  child: Icon(
                                    IconlyBroken.camera,
                                    size: 22,
                                  ),
                                ),
                              )
                            ],
                          ):Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: profileImage==null?
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage('${model.image}'),
                                ):CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(profileImage),

                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  SocialCubit.get(context).removePickedProfileImage();
                                },
                                icon: const CircleAvatar(
                                  child: Icon(
                                    Icons.close,
                                    size: 22,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15,),
                    if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                      Row(
                      children: [
                        if(SocialCubit.get(context).profileImage!=null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  isUpperCase: false,
                                  function: (){
                                      SocialCubit.get(context).uploadProfileImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text);
                                    },
                                  text: 'Upload Profile',
                                  radius: 5,
                                  height: 40
                                ),
                                if(state is SocialUploadProfileImageLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            )
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if(SocialCubit.get(context).coverImage!=null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  isUpperCase: false,
                                  function: (){
                                    SocialCubit.get(context).uploadCoverImage(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text);
                                  },
                                  text: 'Upload Cover',
                                  radius: 5,
                                  height: 40
                                ),
                                if(state is SocialUploadCoverImageLoadingState)
                                  const LinearProgressIndicator(),
                              ],
                            ),
                        ),
                      ],
                    ),
                    if(SocialCubit.get(context).profileImage!=null||SocialCubit.get(context).coverImage!=null)
                      const SizedBox(height: 15,),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        label: 'Name',
                        prefix: IconlyBroken.user2,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'Name must not be empty';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: bioController,
                        type: TextInputType.text,
                        label: 'Bio',
                        prefix: IconlyBroken.infoCircle,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'Name must not be empty';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        label: 'Phone',
                        prefix: IconlyBroken.call,
                        validate: (String value){
                          if(value.isEmpty){
                            return 'Phone must not be empty';
                          }
                          return null;
                        }
                    ),
                  ],
                ),
              ),
            ),
        );
      },
    );
  }
}
