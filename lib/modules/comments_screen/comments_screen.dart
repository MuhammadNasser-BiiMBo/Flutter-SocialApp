import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/models/comment_model.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:hive/shared/styles/colors.dart';
import 'package:intl/intl.dart';



class CommentsScreen extends StatelessWidget {
  final String postId;
  final int postIndex;
   CommentsScreen({Key? key,required this.postId,required this.postIndex}) : super(key: key);

  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var comments = SocialCubit.get(context).comments;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: (){
                  SocialCubit.get(context).getPosts();
                  Navigator.pop(context);
                },
              ),
              title: const Text(
                'Comments',

              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ConditionalBuilder(
                    condition: state is! SocialGetAllUsersLoadingState,
                    fallback: (BuildContext context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    builder: (context) => ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            buildCommentItem(comments[index],postId,postIndex,index, context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        itemCount: comments.length),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      children:  [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                onFieldSubmitted: (String s){
                                  SocialCubit.get(context).commentPost(
                                    postId,
                                    commentController.text,
                                    DateFormat.yMd().add_Hms().format(DateTime.now()),
                                    postIndex,
                                  );
                                  commentController.text='';
                                },
                                controller: commentController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type your comment here ...',
                                ),
                              ),
                            )
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: (){
                              SocialCubit.get(context).commentPost(
                                  postId,
                                  commentController.text,
                                  DateFormat.yMd().add_Hms().format(DateTime.now()),
                                  postIndex,
                              );
                              commentController.text='';
                            },
                            minWidth: 1,
                            child: const Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Widget buildCommentItem(CommentModel comment, postId, postIndex, index, context,) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.image!),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            // Use a Flexible widget to allow the Text widget
            // to overflow and wrap its content if necessary.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IntrinsicWidth(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(10),
                        bottomStart: Radius.circular(10),
                        bottomEnd: Radius.circular(10),
                      ),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  comment.text!,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    // color: Colors.grey
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                comment.dateTime!.substring(0, 15),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if(comment.uId==SocialCubit.get(context).model!.uId)
                  InkWell(
                  onTap: () {
                    SocialCubit.get(context)
                        .deletePostComment(postId, postIndex, index);
                  },
                  child:  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IntrinsicWidth(
                      child: Row(
                        children: const[
                          Text(
                            'delete',
                            style: TextStyle(
                              color: defaultColor
                            ),

                          ),
                          Icon(
                            IconlyBroken.delete,
                            size: 20,
                            color: defaultColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
