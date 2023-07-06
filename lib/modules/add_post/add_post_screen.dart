import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:hive/shared/components/components.dart';
import 'package:hive/shared/cubit/cubit.dart';
import 'package:hive/shared/cubit/states.dart';
import 'package:intl/intl.dart';


class AddPostScreen extends StatelessWidget {
  AddPostScreen({Key? key}) : super(key: key);


  var textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<SocialCubit,SocialStates>(
      listener:(context,state){
        if(state is ChangeBottomNavState){
          textController.text = "";
          SocialCubit.get(context).removePostImage();
        }
      },
      builder: (context,state){
        var model = SocialCubit.get(context).model;
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
                      defaultTextButton(
                        function: (){
                          if(state is SocialPostImagePickedSuccessState){
                            SocialCubit.get(context).uploadPostImage(
                              text: textController.text,
                              dateTime: DateFormat.yMd().add_Hms().format(DateTime.now()),
                            );
                          }else{
                            SocialCubit.get(context).createPost(
                              text: textController.text,
                              dateTime: DateFormat.yMd().add_Hms().format(DateTime.now())
                            );
                          }
                          textController.text='';
                          SocialCubit.get(context).postImage=null;
                        },
                        text: 'POST')
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
                  if (state is !SocialPostImagePickedSuccessState)
                    Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            SocialCubit.get(context).getPostImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
