import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget defaultButton({
  double? height = 50,
  double width = double.infinity,
  Color background = Colors.blue,
  required VoidCallback function,
  required String text,
  bool isUpperCase = true,
  double radius = 0,
}) =>
    Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: background,
        ),
        height: height,
        width: width,
        child: MaterialButton(
            onPressed: function,
            child: Text(
              isUpperCase ? text.toUpperCase() : text,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )));

Widget defaultAppBar({required BuildContext context, String? title, List<Widget>? actions,})=>AppBar(
  leading: IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: const Icon(
      IconlyBroken.arrowLeft2
    ),

  ),
  title: Text(
    title!
  ),
  actions: actions,
);


Widget defaultTextButton({
  required Function() function,
  required String text,
})=> TextButton(
  onPressed: function,
  child: Text(text),
);
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  VoidCallback? onTap,
  Function? onChange,
  required String label,
  required IconData prefix,
  // final FormFieldValidator<String>? validate,
  required Function validate,
  bool isPassword = false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      onFieldSubmitted: (s){
        onSubmit!(s);
      },
      onChanged:(s) {
        onChange!(s);
      },
      validator: (value){
        return validate(value);
      },
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null ? IconButton(
            icon: Icon(suffix),
            onPressed: suffixPressed,) : null,
          border: const OutlineInputBorder()),
    );

Widget mySeparator() => Padding(
  padding: const EdgeInsetsDirectional.only(start: 20.0),
  child: Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey,
  ),
);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (route)=>false,
);

// void submitOnBoarding(context){
//   CacheHelper.saveData(
//     key: 'onBoarding',
//     value: true,
//   ).then((value){
//     if(value!)
//     {
//       navigateAndFinish(
//         context,
//         ShopLoginScreen(),
//       );
//     }
//   });
// }

void showToast({required String text,required ToastStates state}){
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

enum ToastStates {success,error,warning}

Color chooseToastColor(ToastStates state)
{
  Color color;
  switch (state)
  {
    case ToastStates.success:
      color= Colors.green;
      break;
    case ToastStates.error:
      color= Colors.red;
      break;
    case ToastStates.warning:
      color= Colors.amber;
      break;
  }
  return color;
}

// void signOut(context){
//   CacheHelper.removeData(key: 'token').then((value)  {
//     if(value!) {
//       navigateAndFinish(context,ShopLoginScreen());
//     }
//   });
// }

