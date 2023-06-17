import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

class FeedsScreen extends StatelessWidget {
   FeedsScreen({Key? key}) : super(key: key);

   var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit = SocialCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty,
          builder:(context){
            return SingleChildScrollView(
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
                          image: NetworkImage('https://img.freepik.com/free-photo/happy-curly-haired-girl-makes-thumbs-up-sign-demonstrates-support-respect-someone-smiles-pleasantly-achieves-desirable-goal-wears-white-t-shirt-isolated-yellow-wall_273609-27736.jpg?w=1380&t=st=1675974945~exp=1675975545~hmac=ab63fdf5f047faf5e436f64a564a82be1c99d9e0eb0f7b70a2cab6bb55e1569a'),
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder:(context,index)=> buildPostItem(cubit.posts[index],context,index,commentController),
                    itemCount: cubit.posts.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          },
          fallback: (context)=>const Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }


  Widget buildPostItem(PostModel model ,context,index,commentController) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 15,
    margin: const EdgeInsets.symmetric(horizontal: 10),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
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
                      model.dateTime!,
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
              IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    IconlyBroken.moreSquare,
                  )
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          Text(
            model.text!,
            // textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
              height: 1.3,
              fontSize: 14,
            ),
          ),
          if(model.postImage!='')
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 10.0),
              child: Container(
                height: 250,
                decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image:  DecorationImage(
                      image:NetworkImage(model.postImage!),
                      fit: BoxFit.cover,
                    )
                ) ,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                            '${SocialCubit.get(context).likes[index]} Likes',
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
                          SocialCubit.get(context).commentsNumber[index]!=null?'${SocialCubit.get(context).commentsNumber[index]} Comments':'0 Comments',
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
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(model.image!),
                    ),
                    const SizedBox(width: 15,),
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        controller: commentController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1,
                          overflow: TextOverflow.ellipsis,

                        ),
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsetsDirectional.only(start: 10),
                            label: Text(
                              'write a comment...',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(23)),
                              gapPadding: 2,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 5),
              InkWell(
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
                      'Like',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).likePost(SocialCubit.get(context).postsId[index]);
                },
              ),
              const SizedBox(width: 10,),
              InkWell(
                child: Row(
                  children:  [
                    const Icon(
                      IconlyBroken.arrowUpSquare,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Share',
                      style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                onTap: (){
                  SocialCubit.get(context).commentPost(
                      postId:SocialCubit.get(context).postsId[index],
                      commentData: commentController.text
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),

  );
}


