import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/models/photo_model.dart';
import 'package:hive/modules/edit_profile/edit_profile_screen.dart';
import 'package:hive/modules/photo_screen/photo_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(listener: (context, state) {
      if (state is ChangeBottomNavState) {
        SocialCubit.get(context).removePickedProfileImage();
      }
      if (state is SocialAddPhotoSuccessState) {
        SocialCubit.get(context)
            .getProfilePhotos(SocialCubit.get(context).model!.uId!);
      }
    }, builder: (context, state) {
      var model = SocialCubit.get(context).model;
      var cubit = SocialCubit.get(context);
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                                image: NetworkImage('${model!.coverImage}'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage('${model.image}'),
                      ),
                    )
                  ],
                ),
              ),
              Text(model.name.toString(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 19,
                      )),
              const SizedBox(
                height: 8,
              ),
              Text(model.bio!.isNotEmpty?model.bio!: '',
                  style: Theme.of(context).textTheme.caption),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                                SocialCubit.get(context)
                                    .numberOfUserPosts
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text('Posts',
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontSize: 16
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(
                                SocialCubit.get(context).photos.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text('Photos',
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Text(SocialCubit.get(context).followings.length.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text('Followers',
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontSize: 16
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          SocialCubit.get(context).pickProfilePhoto();
                        },
                        child: const Text('Add Photos'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      navigateTo(context, EditProfileScreen());
                    },
                    child: const Icon(
                      IconlyBroken.edit,
                      size: 20,
                    ),
                  )
                ],
              ),
              if (state is SocialPickPhotoSuccessState)
                OutlinedButton(
                  onPressed: () {
                    SocialCubit.get(context).uploadProfilePhoto(
                        dateTime:
                            DateFormat.yMd().add_Hms().format(DateTime.now()));
                  },
                  child: const Text('Confirm'),
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(
                    'Photos',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey.shade700
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  color:  Colors.grey.shade300,
                  height: 1,
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                children: List.generate(cubit.photos.length,
                    (index) => buildPhotoItem(cubit.photos[index], context)),
              )
            ],
          ),
        ),
      );
    });
  }
}

Widget buildPhotoItem(PhotoModel photoModel, context) => Padding(
      padding: const EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          navigateTo(context, PhotoScreen(photoModel: photoModel));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.network(
              photoModel.photo!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
