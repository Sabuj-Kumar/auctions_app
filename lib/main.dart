
import 'package:ebay_ecommerce/local_storage/local_storage.dart';
import 'package:ebay_ecommerce/pages/auth_screen/sign_in_screen.dart';
import 'package:ebay_ecommerce/pages/home_screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool logIn = false;
  @override
  void initState() {
    checkLogIn();
    super.initState();
  }

  checkLogIn()async{
    if(await LocalStorage().tokenExits()){
      logIn = true;
      if(mounted){
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: logIn?const HomeScreen():const SignInScreen(),
    );
  }
}
