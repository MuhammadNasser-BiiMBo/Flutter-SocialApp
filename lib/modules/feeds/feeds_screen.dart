
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/models/post_model.dart';
import 'package:hive/modules/comments_screen/comments_screen.dart';
import 'package:hive/modules/feeds/post_image_screen.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:hive/shared/styles/colors.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);

  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = SocialCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async{ cubit.getPosts(); },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children:  [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 15,
                  margin: const EdgeInsets.all(10),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children:  [
                      const Image(
                        image: AssetImage("assets/images/feed_img.jpg"),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                      Container(
                        color: Colors.black .withOpacity(0.3),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Communicate With Friends',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ConditionalBuilder(
                  condition: cubit.posts.isNotEmpty&&cubit.model!.uId!.isNotEmpty&&(cubit.likesNumber.length==cubit.posts.length),
                  builder:(context){
                    FirebaseMessaging.onMessage.listen((event) {
                      SocialCubit.get(context).addNotifications(event);
                      showToast(text: 'on Message', state: ToastStates.success);
                    });
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder:(context,index){
                        // cubit.getPostLikes(cubit.postsId[index],index );
                        // cubit.getPostComments(cubit.postsId[index],index);
                        return buildPostItem(cubit.posts[index],context,index,commentController);
                      },
                      itemCount: cubit.posts.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    );
                  },
                  fallback: (context) {
                    return  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          'No Post Available...',
                          style: TextStyle(
                              fontSize: 18,color: Colors.grey.shade700
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        );
      },
    );


  }


  Widget buildPostItem(PostModel model ,context,index,commentController) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 15,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(model.image!),
                ),
                const SizedBox(width:  20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Row(
                        children:  [
                          Text(
                            model.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 17,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        model.dateTime!.substring(0,15),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.grey,
                            height: 1.4
                        ),
                      ),
                    ],
                  ),
                ),
                if(model.uId==SocialCubit.get(context).model!.uId)
                  IconButton(
                      onPressed: (){
                        SocialCubit.get(context).deletePost(model.dateTime!,model.uId!);
                      },
                      icon: const Icon(
                        IconlyBroken.delete,
                      )
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.text!,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    height: 1.3,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if(model.postImage!='')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 10.0,end: 2,start: 2),
              child: InkWell(
                onTap: (){
                  navigateTo(context, PostImageScreen(image: model.postImage!,uploadDate:model.dateTime!));
                },
                child: Container(
                  height: 300,
                  padding: EdgeInsets.zero,
                  decoration:BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(5),
                      image:  DecorationImage(
                        image:NetworkImage(model.postImage!),
                        fit: BoxFit.contain,
                      )
                  ) ,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children:  [
                          const Icon(
                            IconlyBroken.heart,
                            size: 18,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${SocialCubit.get(context).likesNumber[index]} Likes',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          Icon(
                            IconlyBroken.chat,
                            size: 18,
                            color: Colors.blue[400],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${SocialCubit.get(context).commentsNumber[index]} comments',
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0,left: 10,right: 10),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              SocialCubit.get(context).isLike[index]?
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Icon(
                          Icons.heart_broken,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Unlike',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15
                          ),
                        ),
                      ],
                    ),
                    onTap: (){
                      SocialCubit.get(context).unLikePost(SocialCubit.get(context).postsId[index],index);
                    },
                  ),
                ),
              ):
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Icon(
                          IconlyBroken.heart,
                          size: 18,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15
                          ),
                        ),
                      ],
                    ),
                    onTap: (){
                      SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index],index);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Container(
                  color: Colors.grey.shade400,
                  width: 1,
                  height: 36,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        const Icon(
                          IconlyBroken.chat,
                          size: 18,
                          color: defaultColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Comment',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 15
                          ),
                        ),
                      ],
                    ),
                    onTap: (){
                      SocialCubit.get(context).getPostComments(SocialCubit.get(context).postsId[index],index);
                      navigateTo(context,  CommentsScreen(postId:SocialCubit.get(context).postsId[index],postIndex: index));
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),

  );
}


