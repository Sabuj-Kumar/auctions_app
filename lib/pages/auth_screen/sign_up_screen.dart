
import 'package:ebay_ecommerce/authentication/auth.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_button.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../neccesary_component/custom_input_field.dart';
import '../../utils/colors.dart';

import '../home_screen/home_screen.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  String? errorMessage;
  bool showError = false;
  bool notMatch = false;
  Future<void> createUser()async{
    try{
      await Auth().createUser(email: email.text, pass: pass.text);
      if(mounted){
        setState(() {
          showError = false;
        });
        if(mounted){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));
        }
      }
    }on FirebaseAuthException catch(error){
      setState(() {
        showError = true;
        errorMessage = error.message;
      });
        print("error $errorMessage");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Auction Products",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(height: width * 0.05),
                    const CustomText(text: "Create Account",fontWeight: FontWeight.w600,fontSize: 30),
                    SizedBox(height: width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomText(text: "Email",fontWeight: FontWeight.w600,fontSize: 14),
                        ),
                        CustomInputField(controller: email,validate: (value){
                          if(value == null || value.isEmpty){
                            return "Enter Email";
                          }
                          return null;
                        }),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomText(text: "Password",fontWeight: FontWeight.w600,fontSize: 14),
                        ),
                        CustomInputField(controller: pass,suffixIcon:true,validate: (value){
                          if(value == null || value.isEmpty){
                            return "Enter Password";
                          }
                          return null;
                        }),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: CustomText(text: "Confirm Password",fontWeight: FontWeight.w600,fontSize: 14),
                        ),
                        CustomInputField(controller: confirmPass,suffixIcon:true,inputAction: true,validate: (value){
                          if(value == null || value.isEmpty){
                            return "Enter Password";
                          }
                          return null;
                        }),
                        if(notMatch)const Padding(
                          padding:  EdgeInsets.symmetric(vertical: 8.0),
                          child:  CustomText(text: "Password Not Match",fontWeight: FontWeight.w500,fontSize: 16,color: redColor,),
                        ),
                      ],
                    ),
                  ],
                ),
                if(showError)CustomText(text: "$errorMessage",fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black.withOpacity(0.5)),
                Column(
                  children: [
                    Row(
                    children: [
                      const CustomText(text: "Have an account? ",color: Colors.black,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const SignInScreen()));
                        },
                        child: const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child:  CustomText(text: "Log In",color: Colors.red,),
                        ),
                      ),
                    ],
                  ),
                    CustomButton(buttonText: 'Create Account', onPressed: () async{
                      if(formKey.currentState!.validate()){
                        if(pass.text != confirmPass.text){
                          setState(() {
                            notMatch=true;
                          });
                        }else{
                          setState(() {
                            notMatch=false;
                          });
                          createUser();

                          /*if(mounted){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MoveToLogInOrHomePage()));
                          }*/
                        }
                      }
                    },)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
