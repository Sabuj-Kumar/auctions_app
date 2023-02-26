
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_ecommerce/local_storage/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/auction_product_model.dart';
import '../repositories/repository.dart';

final provider = ChangeNotifierProvider((ref) => Provider());

class Provider extends ChangeNotifier{

  List<AuctionProductModel>? auctionProductModelList;
  List<AuctionProductModel> homeProducts = [];
  List<AuctionProductModel>? userData;
  AuctionProductModel? auctionProductModel;

  Future<bool> getAllData()async{
    auctionProductModelList = await Repository.getAllData();
    if(auctionProductModelList != null){
      String? userID = await LocalStorage.getToken();
      List<AuctionProductModel> temp = [];
      for(int i = 0; i < auctionProductModelList!.length;i++){
        String? user = auctionProductModelList![i].path;
        bool value = user!.startsWith(userID!);
        if(!value){
          temp.add(auctionProductModelList![i]);
        }
      }
      homeProducts = temp;
    }
    notifyListeners();
    return auctionProductModelList != null;
  }

  Future<bool> getUserData()async{
    userData = await Repository.getUserData();
    notifyListeners();
    return auctionProductModelList != null;
  }

  setDetailsAuctionModel(String auctionModelId){
    int index = -1;
    if(auctionProductModelList != null && auctionProductModelList!.isNotEmpty){
      index = auctionProductModelList!.indexWhere((element) => auctionModelId == element.path);
      if(index >= 0){
        auctionProductModel = auctionProductModelList![index];
        print('path $auctionModelId');
      }
    }
    notifyListeners();
  }

  giveBid({String productId="",int bid = -1})async{

    String user = "";
    String? userId = await LocalStorage.getToken();
    List<UserBidsModel> userModelList = auctionProductModel!.userBids!;
    UserBidsModel userBidsModel;

    for(int index = 0; index <productId.length;index++){
      if(productId[index] == '+'){
        break;
      }
      user += productId[index];
    }

    int index = userModelList.indexWhere((element) => element.useBidId == userId);
    if(index >= 0){
      userModelList.removeAt(index);
    }

    final events1 = FirebaseFirestore.instance.collection('totalBids').doc(productId);
    final events2 = FirebaseFirestore.instance.collection('userAuctions').doc(user).collection("AuctionList").doc(productId);

    userBidsModel = UserBidsModel(useBidId: userId,bid: bid);
    userModelList.add(userBidsModel);

    events1.update({"userBids":List<dynamic>.from(userModelList.map((x) => x.toJson()))});
    events2.update({"userBids":List<dynamic>.from(userModelList.map((x) => x.toJson()))});

    notifyListeners();
  }
}