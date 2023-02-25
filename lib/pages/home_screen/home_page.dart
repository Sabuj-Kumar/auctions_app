import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Auction Gallery",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        width: width,
        child: Column(
          children: [
            SizedBox(height: width * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){}, child:Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(children: [
                      Image.asset("assets/images/auctions.png",scale: 6,),
                      const Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(text: "MyAuctions",fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black,),
                      )
                    ],),
                  ),
                )),
                const SizedBox(width: 25),
                TextButton(onPressed: (){}, child:Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: const [
                      Icon(Icons.add,color: Colors.black,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomText(text: "Create",fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black,),
                      )
                    ],),
                  ),
                )),
              ],
            ),
            Expanded(child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20
                  ),
                  itemBuilder: (context,index)=>GestureDetector(
                    onTap: (){},
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}
