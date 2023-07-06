import 'package:flutter/material.dart';

class PostImageScreen extends StatelessWidget {
  final String image;
  final String uploadDate;
  PostImageScreen({super.key, required this.image,required this.uploadDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Image'),
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
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  'Upload Date : ${uploadDate.substring(0,15)}'
              )
            ],
          ),
        ),
      ),
    );
  }
}
