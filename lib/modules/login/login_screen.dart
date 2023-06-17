import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'package:social_app/shared/network/cache_helper/cache_helper.dart';


import '../../shared/components/components.dart';
import '../register/register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
   var emailController = TextEditingController();
   var passwordController = TextEditingController();
   var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialLoginCubit,SocialLoginStates>(
      listener:(context,state){
        if (state is SocialLoginErrorState) {
          showToast(text: state.error, state: ToastStates.error);
        }
        if(state is SocialLoginSuccessState){
          CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
          ).then((value) {
              navigateAndFinish(context, const SocialLayout());
          });
        }
      } ,
      builder: (context,state){
        var loginCubit = SocialLoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style:
                        Theme.of(context).textTheme.headline4?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'login now to Communicate with Friends ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your email address';
                          }
                        },
                        onSubmit: () {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Password',
                          prefix: Icons.lock_outlined,
                          suffix: Icons.visibility_outlined,
                          suffixPressed:(){
                            // loginCubit.changePasswordVisibility();
                          } ,
                          isPassword: loginCubit.isPassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                          },
                          onSubmit: (value){
                            if (formKey.currentState!.validate()) {
                              // loginCubit.userLogin(
                              //     email: emailController.text,
                              //     password: passwordController.text);
                            }
                          }
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                        condition: state is! SocialLoginLoadingState,
                        builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                loginCubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'Login'),
                        fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            'you don\'t have an account ? ',
                          ),
                          defaultTextButton(
                              function: () {
                                navigateTo(context,  RegisterScreen());
                              },
                              text: 'Register Now '),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );;
  }
}
