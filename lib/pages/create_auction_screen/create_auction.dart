
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_ecommerce/local_storage/local_storage.dart';
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/neccesary_component/screen_size.dart';
import 'package:ebay_ecommerce/providers/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../neccesary_component/custom_button.dart';
import '../../neccesary_component/custom_input_field.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';

class AuctionCreate extends ConsumerStatefulWidget {
  final bool edit;
  const AuctionCreate({Key? key,this.edit = false}) : super(key: key);

  @override
  ConsumerState<AuctionCreate> createState() => _AuctionCreateState();
}

class _AuctionCreateState extends ConsumerState<AuctionCreate> {
  TextEditingController productName = TextEditingController();
  TextEditingController productDescriptions = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  final formKey = GlobalKey<FormState>();
  XFile? image;
  DateTime? selectedDate;
  String imageUrl = "";
  bool check = false;
  @override
  void initState() {
    getEditAuction();
    super.initState();
  }

  getEditAuction(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      if(widget.edit){
        productName.text = ref.watch(provider).auctionProductModel!.productName!;
        productDescriptions.text = ref.watch(provider).auctionProductModel!.productDescriptions!;
        productPrice.text = ref.watch(provider).auctionProductModel!.minimumBid!.toString();
        selectedDate = DateTime.fromMillisecondsSinceEpoch(ref.watch(provider).auctionProductModel!.dateTime! * 1000);
        if(mounted){
          setState(() {});
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(onTap: (){
          Navigator.pop(context);
        },child: const Center(child: CustomText(text: "Back",fontSize: 15,fontWeight: FontWeight.w600,color: Colors.white,)),),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: CustomText(text: widget.edit?"Edit Auction":"Add New Auction",fontWeight: FontWeight.w600,fontSize: 20,color: whiteColor,),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                   children: [
                     SizedBox(height: width * 0.05),
                     CustomText(text: widget.edit?"Edit Auction":"Add Your Auction",fontWeight: FontWeight.w600,fontSize: 30,color: Colors.deepPurple),
                     SizedBox(height: width * 0.05),
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Padding(
                               padding: EdgeInsets.symmetric(vertical: 8.0),
                               child: CustomText(text: "Product Name",fontWeight: FontWeight.w600,fontSize: 14),
                             ),
                             CustomInputField(controller: productName,validate: (value){
                               if(value == null || value.isEmpty){
                                 return "Product Name";
                               }
                               return null;
                             }),
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Padding(
                               padding: EdgeInsets.symmetric(vertical: 8.0),
                               child: CustomText(text: "Description",fontWeight: FontWeight.w600,fontSize: 14),
                             ),
                             CustomInputField(controller: productDescriptions,validate: (value){
                               if(value == null || value.isEmpty){
                                 return "Enter Descriptions";
                               }
                               return null;
                             }),
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const Padding(
                               padding: EdgeInsets.symmetric(vertical: 8.0),
                               child: CustomText(text: "Product Price",fontWeight: FontWeight.w600,fontSize: 14),
                             ),
                             CustomInputField(controller: productPrice,inputAction: true,keyboardType:TextInputType.number,validate: (value){
                               if(value == null || value.isEmpty){
                                 return "Enter Price";
                               }
                               return null;
                             }),
                           ],
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             SizedBox(height: width * 0.05),
                             GestureDetector(
                               onTap: (){
                                 _selectDate(context);
                               },
                               child: Container(
                                 width:width * 0.3,
                                 height: width * 0.1,
                                 decoration: BoxDecoration(
                                   color: Colors.grey.withOpacity(0.2),
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 child: Center(child: CustomText(text:selectedDate==null?"Pick Date":"${selectedDate?.day.toString().padLeft(2,'0')}/${selectedDate?.month.toString().padLeft(2,'0')}/${selectedDate?.year}",)),
                               ),
                             ),
                           ],
                         ),
                         SizedBox(height: width * 0.05),
                         GestureDetector(
                           onTap: (){
                             _dialogBuilder(context);
                           },
                           child: CustomText(text: image==null?widget.edit?"image url: ${ref.watch(provider).auctionProductModel!.url}":"Add Images..":"File name: ${image?.name}",fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black54),
                         ),
                         if(check)const CustomText(text: "Product Image and Auction Data is needed.")
                       ],
                     ),
                   ],
                 ),
                  widget.edit?CustomButton(buttonText: 'Edit Auction', onPressed: () async{
                    setState(() {
                      check = false;
                    });
                    if(mounted){
                      if(formKey.currentState!.validate()){
                        String? userID = await LocalStorage.getToken();
                        if(selectedDate != null){
                          try{
                            if(image != null){
                              String imageName = DateTime.now().millisecondsSinceEpoch.toString();
                              Reference referenceRoot = FirebaseStorage.instance.ref().child("images");
                              Reference uploadImageName = referenceRoot.child(imageName);
                              await uploadImageName.putFile(File(image!.path));
                              imageUrl = await uploadImageName.getDownloadURL();
                              print("image url $imageUrl");
                            }
                            final totalBids = FirebaseFirestore.instance.collection("totalBids").doc(ref.watch(provider).auctionProductModel!.path!);
                            if(selectedDate != null){
                              await totalBids.set({
                                "productName": productName.text,
                                "productDescriptions": productDescriptions.text,
                                "url": image != null?imageUrl:ref.watch(provider).auctionProductModel?.url,
                                "minimumBid": int.parse(productPrice.text),
                                "dateTime": selectedDate,
                                "path": ref.watch(provider).auctionProductModel!.path!,
                                "userBids": List<dynamic>.from(ref.watch(provider).auctionProductModel!.userBids!.map((x) => x.toJson()))
                              },SetOptions(merge: true));
                            }

                            final docs = FirebaseFirestore.instance.collection("userAuctions").doc("$userID").collection("AuctionList").doc(ref.watch(provider).auctionProductModel!.path!);

                            if(selectedDate != null){
                              await docs.set({
                                "productName": productName.text,
                                "productDescriptions": productDescriptions.text,
                                "url": image != null?imageUrl:ref.watch(provider).auctionProductModel?.url,
                                "minimumBid": int.parse(productPrice.text),
                                "dateTime": selectedDate,
                                "path": ref.watch(provider).auctionProductModel!.path!,
                                "userBids": List<dynamic>.from(ref.watch(provider).auctionProductModel!.userBids!.map((x) => x.toJson()))
                              },SetOptions(merge: true));
                            }
                            if(imageUrl.isNotEmpty && selectedDate != null){
                              if(mounted){
                                selectedDate = null;
                              }
                            }
                            if(mounted){
                              if(mounted){
                                await ref.read(provider).getAllData();
                              }
                              if(mounted){
                                await ref.read(provider).setDetailsAuctionModel(ref.watch(provider).auctionProductModel!.path!);
                              }
                              if(mounted){
                                print("call ses");
                                setState((){});
                              }
                              Navigator.of(context).pop(true);
                            }
                          }catch(e){

                          }
                        }else{
                          setState(() {
                            check = true;
                          });
                        }
                      }
                    }
                  },
                  ):CustomButton(buttonText: 'Add Auction', onPressed: () async{
                      setState(() {
                        check = false;
                      });
                      if(mounted){
                        if(formKey.currentState!.validate()){
                          String? userID = await LocalStorage.getToken();
                          if(image != null && selectedDate != null){
                            String imageName = DateTime.now().millisecondsSinceEpoch.toString();
                            Reference referenceRoot = FirebaseStorage.instance.ref().child("images");
                            Reference uploadImageName = referenceRoot.child(imageName);
                            try{
                              await uploadImageName.putFile(File(image!.path));
                              imageUrl = await uploadImageName.getDownloadURL();
                              print("image url $imageUrl");
                              String paths = "$userID+${DateTime.now().millisecondsSinceEpoch}";

                              final totalBids = FirebaseFirestore.instance.collection("totalBids").doc(paths);
                              if(selectedDate != null){
                                await totalBids.set({
                                  "productName": productName.text,
                                  "productDescriptions": productDescriptions.text,
                                  "url": imageUrl,
                                  "minimumBid": int.parse(productPrice.text),
                                  "dateTime": selectedDate,
                                  "path": paths,
                                  "userBids": []
                                });
                              }

                              final docs = FirebaseFirestore.instance.collection("userAuctions").doc("$userID").collection("AuctionList");

                              if(selectedDate != null){
                                await docs.doc(paths).set({
                                  "productName": productName.text,
                                  "productDescriptions": productDescriptions.text,
                                  "url": imageUrl,
                                  "minimumBid": int.parse(productPrice.text),
                                  "dateTime": selectedDate,
                                  "path": paths,
                                  "userBids": []
                                });
                              }

                              if(imageUrl.isNotEmpty && selectedDate != null){
                               if(mounted){
                                 selectedDate = null;
                                 Navigator.pop(context);
                               }
                              }
                            }catch(e){

                            }
                          }else{
                            setState(() {
                              check = true;
                            });
                          }

                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Product Image'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Image.asset(camera,scale: 8,),
                onPressed: () {
                  pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Image.asset(gallery,scale: 8,),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageSource)async{
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: imageSource);
    if(mounted){
      setState(() {

      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2201));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print("data time $selectedDate");
      });
    }
  }
}
