import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);


  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state){} ,
      builder: (context,state){
        var model = SocialCubit.get(context).model;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                SocialCubit.get(context).posts =[];
                SocialCubit.get(context).getPosts();
                SocialCubit.get(context).removePostImage();
              },
              icon: const Icon(IconlyBroken.arrowLeft2),
            ),
            title: const Text('Create Post'),
            actions: [
              defaultTextButton(
                function: (){
                  if(SocialCubit.get(context).postImage==null){
                    SocialCubit.get(context).createPost(
                        text: textController.text,
                        dateTime: DateFormat.yMMMEd().format(DateTime.now()),
                    );
                  }else{
                    SocialCubit.get(context).uploadPostImage(
                        text: textController.text,
                        dateTime: DateFormat.yMMMEd().format(DateTime.now()),
                    );
                  }
                },
                text: 'POST',
              )
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  if(state is SocialCreatePostLoadingState)
                    const LinearProgressIndicator(),
                  if(state is SocialCreatePostLoadingState)
                    const SizedBox(
                      height: 20,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(model!.image!),
                      ),
                      const SizedBox( width:  20,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:   [
                            Text(
                              model.name!,
                              style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              height: 1.4,
                          ),
                        ),
                            const SizedBox(height: 3),
                            const Text(
                              'public',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1.4
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'What\'s in your mind ...',
                        border: InputBorder.none,

                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if(SocialCubit.get(context).postImage!=null)
                    Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 250,
                        decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image:  DecorationImage(
                                image:FileImage(SocialCubit.get(context).postImage!),
                                fit: BoxFit.cover
                            )
                        ) ,
                      ),
                      IconButton(
                        onPressed: (){
                          SocialCubit.get(context).removePostImage();
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).getPostImage();
                          },
                          child: Row(
                            children: const [
                              Icon(
                                IconlyBroken.image
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Add Photos')
                            ],
                          ),

                      )),
                      Expanded(
                        child: TextButton(
                          onPressed: () {  },
                          child: const Text('# tags'),

                      )),
                    ],
                  )
                ],
              ),
          ),
        );
      },
    );
  }
}
