import 'package:flutter/material.dart';
import 'package:hive/models/photo_model.dart';

class PhotoScreen extends StatelessWidget {
  final PhotoModel photoModel;
  PhotoScreen({super.key, required this.photoModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Photo'),
      ),
      body: Container(
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 3,
                      color: Colors.black
                    )
                  ),
                  child: Image.network(
                      photoModel.photo!,
                    // fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Upload Date : ${photoModel.dateTime!.substring(0,15)}'
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        ),
      );
  }
}
