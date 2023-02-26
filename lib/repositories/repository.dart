
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_ecommerce/local_storage/local_storage.dart';
import 'package:ebay_ecommerce/models/auction_product_model.dart';


class Repository{

  static Stream<List<AuctionProductModel>> readAllData()=>
      FirebaseFirestore.instance.collection("totalBids").
      snapshots().
      map((snapshot) =>
          snapshot.docs.map((events) => AuctionProductModel.fromJson(events.data())).toList()
      );

  static Future<List<AuctionProductModel>> getAllData() async{
    final events = await FirebaseFirestore.instance.collection('totalBids').get();
    return events.docs.map((events) => AuctionProductModel.fromJson(events.data())).toList();
  }

  static Future<List<AuctionProductModel>>? getUserData() async{
    String? userId = await LocalStorage.getToken();
    print("$userId");
    final events = await FirebaseFirestore.instance.collection('userAuctions').doc("$userId").collection("AuctionList").get();
    return events.docs.map((events) => AuctionProductModel.fromJson(events.data())).toList();
  }

  static Future<AuctionProductModel?>? singleBid({required String productId}) async{

    AuctionProductModel? auctionProductModel;

    final events = FirebaseFirestore.instance.collection('totalBids').doc(productId);
    final snapShots =await events.get();
    if(snapShots.exists){
      auctionProductModel = AuctionProductModel.fromJson(snapShots.data()!);
    }
    return auctionProductModel;
  }
}