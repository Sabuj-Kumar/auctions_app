
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/provider.dart';
import '../auction_details_screen/auction_details_screen.dart';

class UserAuctionListScreen extends ConsumerStatefulWidget {
  const UserAuctionListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserAuctionListScreen> createState() => _UserAuctionListState();
}

class _UserAuctionListState extends ConsumerState<UserAuctionListScreen> {

  getUserData(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      bool status = await ref.read(provider).getUserData();
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
  void initState() {
    getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = ScreenSize(context).height;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: const Center(child: CustomText(text: "Back",fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,)),),
        title: const CustomText(text: "Personal Auctions",color: whiteColor,fontSize: 20,),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              ref.watch(provider).userData == null? const Expanded(child: Center(child: CircularProgressIndicator())):Expanded(child: GridView.builder(
                itemCount:ref.watch(provider).userData!.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20
                ),
                itemBuilder: (context,index)=>
                    GestureDetector(
                      onTap: (){
                        print('path ${ref.watch(provider).userData![index].path!}');
                        ref.read(provider).setDetailsAuctionModel(ref.watch(provider).userData![index].path!);
                        if(mounted){
                          Navigator.push(context,MaterialPageRoute(builder:(context)=>const AuctionDetailsScreen(detailsPageShowFromUserList: true,))).then((value) {
                            if(mounted){
                              print("asche ");
                              getUserData();
                            }
                            if(mounted){
                              setState(() {});
                            }
                          });
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: "${ref.watch(provider).userData![index].url}",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: imageProvider
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Center(child: CustomText(text: '${ref.watch(provider).userData![index].productName}',))),
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
