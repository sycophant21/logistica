class GoodsInformation {
  double totalWeight;
  String commodity;
  String description;

  GoodsInformation(this.totalWeight, this.commodity, this.description);

  static GoodsInformation fromJson(json) {
    double totalWeight = json['totalWeight'];
    String commodity = json['commodity'];
    String description = json['description'];
    return GoodsInformation(totalWeight, commodity, description);
  }

  static Map toJson(GoodsInformation goodsInformation) {
    return {
      'totalWeight': goodsInformation.totalWeight,
      'commodity': goodsInformation.commodity,
      'description': goodsInformation.description,
    };
  }

  static GoodsInformation empty() {
    return GoodsInformation(0.0, '', '');
  }
}
