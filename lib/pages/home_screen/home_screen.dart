import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/provider.dart';
import '../../utils/colors.dart';
import '../auction_details_screen/auction_details_screen.dart';
import '../auth_screen/user_account.dart';
import '../create_auction_screen/create_auction.dart';
import '../user_auction_list_screen/user_auction_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    getAllData();
    super.initState();
  }
  getAllData(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      bool status = await ref.read(provider).getAllData();
      if(status){
        print('oka');
        if(mounted){
          setState(() {});
        }
      }else{
        print('ase nai oka');
      }

    });
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Auction Gallery",style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserAccount()));
          }, child: Container(
            padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: whiteColor,
                shape: BoxShape.circle
              ),
              child: const Icon(Icons.person,color: Colors.cyan)
          ))
        ],
      ),
      body: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserAuctionListScreen())).then((value) {
                        getAllData();
                      });
                  }, child:Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(children: [
                        Image.asset(auction,scale: 6,),
                        const Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 8.0),
                          child: CustomText(text: "MyAuctions",fontSize: 18,fontWeight: FontWeight.w500,color: Colors.black,),
                        )
                      ],),
                    ),
                  )),
                  const SizedBox(width: 25),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AuctionCreate())).then((value) {
                      getAllData();
                    });
                  }, child:Container(
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
              SizedBox(height: width * 0.05,),
              /*Expanded(child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: StreamBuilder<List<AuctionProductModel>>(
                  stream: Repository.readAllData(),
                  builder: (BuildContext context,snapshot) {
                    if(snapshot.hasError){
                      return const CustomText(text:"some thing wrong");
                    }
                    else if(snapshot.hasData){
                      return GridView.builder(
                          itemCount: snapshot.data!.length,
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
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage("${snapshot.data?[index].url}")
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ));
                    }
                    else{
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              )),*/
              ref.watch(provider).auctionProductModelList == null && ref.watch(provider).homeProducts.isNotEmpty?const CircularProgressIndicator():Expanded(child: GridView.builder(
                  itemCount:ref.watch(provider).homeProducts.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20
                  ),
                  itemBuilder: (context,index)=>
                      GestureDetector(
                        onTap: (){
                          print("pressed");
                            ref.read(provider).setDetailsAuctionModel(ref.watch(provider).homeProducts[index].path!);
                            if(mounted){
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>const AuctionDetailsScreen()));
                            }
                        },
                        child: CachedNetworkImage(
                          imageUrl: "${ref.watch(provider).homeProducts[index].url}",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: imageProvider
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              width: width * 0.2,
                              child: Column(
                                children: [
                                  Container(
                                     width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Center(child: CustomText(text: '${ref.watch(provider).homeProducts[index].productName}',))),
                                ],
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60.0,vertical: 60),
                            child: CircularProgressIndicator(color: purpleColor,),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                     ))
            ],
          ),
        ),
      ),
    );
  }
}
