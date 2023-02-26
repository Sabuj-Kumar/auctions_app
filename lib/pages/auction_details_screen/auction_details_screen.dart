
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../neccesary_component/custom_input_field.dart';
import '../../providers/provider.dart';
import '../create_auction_screen/create_auction.dart';

class AuctionDetailsScreen extends ConsumerStatefulWidget {
  final bool detailsPageShowFromUserList;
  const AuctionDetailsScreen({Key? key,this.detailsPageShowFromUserList = false}) : super(key: key);

  @override
  ConsumerState<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends ConsumerState<AuctionDetailsScreen> {

  TextEditingController bid = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String covertDateTime(String time){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(time) * 1000);
    return "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year.toString().padLeft(2,'0')}";
  }
  callSetState()async{

  }
  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const CustomText(text: "Product Details",color: whiteColor,fontSize: 20),
        centerTitle: true,
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: const Center(child: CustomText(text: "Back",fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,)),),
        actions: widget.detailsPageShowFromUserList?[
            TextButton(onPressed: (){
              ref.read(provider).setDetailsAuctionModel(ref.watch(provider).auctionProductModel!.path!);
              if(mounted){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AuctionCreate(edit: true)));
              }
              setState(() {});
              if(mounted){callSetState();}
            }, child: const CustomText(text: "Edit",color: whiteColor,))
        ]:null,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: width * 0.05),
                  const CustomText(text: "Product Image",color: Colors.cyan,fontSize: 20),
                  SizedBox(height: width * 0.02),
                  CachedNetworkImage(
                    imageUrl: "${ref.watch(provider).auctionProductModel?.url}",
                    imageBuilder: (context, imageProvider) => Container(
                      height: width * 0.5,
                      width: width * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: imageProvider
                        ),

                      ),
                    ),
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.0,vertical: 50),
                      child: CircularProgressIndicator(color: purpleColor,),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(
                              text: "Product Name :  ",
                              style: const TextStyle(color: blackColor,fontWeight: FontWeight.w700,fontSize:16),
                              children: [
                                TextSpan(
                                  text: "${ref.watch(provider).auctionProductModel?.productName}",
                                  style: const TextStyle(color: Colors.cyan,fontSize: 16)
                                )
                              ]
                          )),
                          SizedBox(height: width * 0.02),
                          const CustomText(text: "Product Details : ",color: blackColor,fontWeight: FontWeight.w700,fontSize:16),
                          SizedBox(height: width * 0.02),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey,width: 0.3)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                              child: CustomText(text: "${ref.watch(provider).auctionProductModel?.productDescriptions}",color: blackColor.withOpacity(0.7)),
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          RichText(text: TextSpan(
                              text: "Minimum Bid Price :  ",
                              style: const TextStyle(color: blackColor,fontWeight: FontWeight.w700,fontSize:16),
                              children: [
                                TextSpan(
                                  text: "${ref.watch(provider).auctionProductModel?.minimumBid}",
                                  style: const TextStyle(color: Colors.cyan,fontSize: 16)
                                )
                              ]
                          )),
                          SizedBox(height: width * 0.02),
                          RichText(text: TextSpan(
                              text: "End Date :  ",
                              style: const TextStyle(color: blackColor,fontWeight: FontWeight.w700,fontSize:16),
                              children: [
                                TextSpan(
                                  text: covertDateTime("${ref.watch(provider).auctionProductModel?.dateTime}"),
                                  style: const TextStyle(color: Colors.cyan,fontSize: 16)
                                )
                              ]
                          )),
                          SizedBox(height: width * 0.05),
                          if(ref.watch(provider).auctionProductModel!.userBids!.isNotEmpty)
                            const CustomText(text: "Bid List:",fontSize: 18,color: Colors.cyan),
                          SizedBox(height: width * 0.02),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(ref.watch(provider).auctionProductModel!.userBids!.length, (index) => Column(
                                 children: [
                                   CustomText(text: "${index + 1} : ${ref.watch(provider).auctionProductModel!.userBids![index].bid} TK",)
                                 ],
                              )),
                            ),
                          ),
                          SizedBox(height: width * 0.05),
                          widget.detailsPageShowFromUserList?const SizedBox():Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(text: "Bid It...",fontSize: 25,color: Colors.cyan),
                              SizedBox(height: width * 0.05),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomInputField(controller: bid,keyboardType:TextInputType.number,inputAction:true,validate: (value){
                                      if(value == null || value.isEmpty){
                                        return "Enter Email";
                                      }
                                      return null;
                                    },),
                                  ),
                                  SizedBox(width: width * 0.05,),
                                  GestureDetector(
                                    onTap: ()async{
                                      if(formKey.currentState!.validate()){
                                        await ref.read(provider).giveBid(
                                            productId: ref.watch(provider).auctionProductModel!.path!,
                                            bid: int.parse(bid.text)
                                        );
                                        if(mounted){
                                          await ref.read(provider).getAllData();
                                        }
                                        if(mounted){
                                          ref.read(provider).setDetailsAuctionModel(ref.watch(provider).auctionProductModel!.path!);
                                        }
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.cyan,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: const Padding(
                                        padding:  EdgeInsets.all(19.0),
                                        child: CustomText(text: "Submit",color: whiteColor,),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
