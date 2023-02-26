
import 'package:ebay_ecommerce/authentication/auth.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_button.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/pages/auth_screen/sign_up_screen.dart';
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../neccesary_component/custom_input_field.dart';
import '../home_screen/home_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {

  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String? errorMessage;
  bool showError = false;

  Future<void> signInUser()async{
    try{
      await Auth().signInWithEmailAndPass(email: email.text, pass: pass.text);
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
      print("error sign in $errorMessage");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height* 0.85;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Auction Products",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: width * 0.05),
                        const CustomText(text: "Please Log In",fontWeight: FontWeight.w600,fontSize: 30),
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
                            },),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: CustomText(text: "Password",fontWeight: FontWeight.w600,fontSize: 14),
                            ),
                            CustomInputField(controller: pass,validate: (value){
                              if(value == null || value.isEmpty){
                                return "Enter Password";
                              }
                              return null;
                            }),
                          ],
                        ),
                      ],
                    ),
                    if(showError)CustomText(text: "$errorMessage",fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black.withOpacity(0.5)),
                    Container(
                      height: width * 0.5,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Icon(Icons.person,size:width* 0.5,color: blackColor.withOpacity(0.1)),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const CustomText(text: "Haven't an account? ",color: Colors.black,),
                            GestureDetector(
                              onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                              },
                              child: const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child:  CustomText(text: "Sign Up",color: Colors.red,),
                              ),
                            ),
                          ],
                        ),
                        CustomButton(buttonText: 'Sign In', onPressed: () async{
                          if(formKey.currentState!.validate()){
                            await signInUser();
                           /* if(mounted){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MoveToLogInOrHomePage()));
                            }*/
                          }
                        })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
