
class AuctionProductModel {
  AuctionProductModel({
    this.productName,
    this.productDescriptions,
    this.url,
    this.minimumBid,
    this.dateTime,
    this.path,
    this.userBids
  });

  final String? productName;
  final String? productDescriptions;
  final String? url;
  final int? minimumBid;
  final int? dateTime;
  final String? path;
  final List<UserBidsModel>? userBids;

  factory AuctionProductModel.fromJson(Map<String, dynamic> json) => AuctionProductModel(
    productName: json["productName"],
    productDescriptions: json["productDescriptions"],
    url: json["url"],
    minimumBid: json["minimumBid"],
    dateTime: json["dateTime"].seconds,
    path: json["path"],
    userBids: json["userBids"] == null ? [] : List<UserBidsModel>.from(json["userBids"]!.map((x) => UserBidsModel.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "productDescriptions": productDescriptions,
    "url": url,
    "minimumBid": minimumBid,
    "DateTime": dateTime,
    "path":path,
    "userBids": userBids == null ? [] : List<dynamic>.from(userBids!.map((x) => x.toJson())),
  };
}
class UserBidsModel {
  UserBidsModel({
    this.useBidId,
    this.bid,
  });

  final String? useBidId;
  final int? bid;

  factory UserBidsModel.fromJson(Map<String, dynamic> json) => UserBidsModel(
    useBidId: json["useBidId"],
    bid: json["bid"],
  );

  Map<String, dynamic> toJson() => {
    "useBidId": useBidId,
    "bid": bid,
  };
}
