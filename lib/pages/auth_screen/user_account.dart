
import 'package:ebay_ecommerce/authentication/auth.dart';
import 'package:ebay_ecommerce/local_storage/local_storage.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/pages/auth_screen/sign_in_screen.dart';
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../neccesary_component/custom_button.dart';

class UserAccount extends ConsumerStatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  ConsumerState<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends ConsumerState<UserAccount> {

  String? userID = '';
  @override
  void initState() {
    setUsrID();
    super.initState();
  }

  setUsrID()async{
    userID = await LocalStorage.getToken();

    if(mounted){
      print('user ud');
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const CustomText(text: "User Account",fontSize: 20,color: whiteColor),
        centerTitle: true,
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: const Center(child: CustomText(text: "Back",fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,)),),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: width * 0.1),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(Icons.person,size: 100,color: whiteColor),
                    ),
                  ),
                  SizedBox(height: width * 0.1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CustomText(text: "UserId :  ",fontSize: 20),
                            Expanded(child: CustomText(text: "$userID",fontSize: 15,color: Colors.cyan,))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              CustomButton(buttonText: 'Log Out', onPressed: () async{
                await Auth().signOut();
                await LocalStorage.removeToken();
                if(mounted){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
                }
              },)
            ],
          ),
        ),
      ),
    );
  }
}
