
class AuctionProductModel {
  AuctionProductModel({
    this.productName,
    this.productDescriptions,
    this.url,
    this.minimumBid,
    this.dateTime,
  });

  final String? productName;
  final String? productDescriptions;
  final String? url;
  final int? minimumBid;
  final DateTime? dateTime;

  factory AuctionProductModel.fromJson(Map<String, dynamic> json) => AuctionProductModel(
    productName: json["productName"],
    productDescriptions: json["productDescriptions"],
    url: json["url"],
    minimumBid: json["minimumBid"],
    dateTime: json["DateTime"],
  );

  Map<String, dynamic> toJson() => {
    "productName": productName,
    "productDescriptions": productDescriptions,
    "url": url,
    "minimumBid": minimumBid,
    "DateTime": dateTime,
  };
}
