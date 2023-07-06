import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/layout/social_layout.dart';
import 'package:hive/shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            navigateAndFinish(context, const SocialLayout());
          }
        },
        builder: (context, state) {
          var cubit = SocialRegisterCubit.get(context);
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
                          'REGISTER',
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
                          'Register now to Communicate with Friends ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'UserName',
                          prefix: Icons.person,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          onSubmit: () {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email',
                          prefix: Icons.email_outlined,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
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
                            suffixPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            isPassword: cubit.isPassword,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                            },
                            onSubmit: (value) {}),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'Phone ',
                          prefix: Icons.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          onSubmit: () {
                            if (formKey.currentState!.validate()) {
                              cubit.userRegister(
                                  email: emailController.text,
                                  phone: phoneController.text,
                                  name: nameController.text,
                                  password: passwordController.text);
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      name: nameController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'register'),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
