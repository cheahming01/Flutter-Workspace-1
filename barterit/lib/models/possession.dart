class Possession {
  String? possessionId;
  String? userId;
  String? possessionName;
  String? possessionType;
  String? possessionDesc;
  String? possessionPrice;
  String? possessionQty;
  String? possessionLat;
  String? possessionLong;
  String? possessionState;
  String? possessionLocality;
  String? possessionDate;

  Possession(
      {this.possessionId,
      this.userId,
      this.possessionName,
      this.possessionType,
      this.possessionDesc,
      this.possessionPrice,
      this.possessionQty,
      this.possessionLat,
      this.possessionLong,
      this.possessionState,
      this.possessionLocality,
      this.possessionDate});

  Possession.fromJson(Map<String, dynamic> json) {
    possessionId = json['possession_id'];
    userId = json['user_id'];
    possessionName = json['possession_name'];
    possessionType = json['possession_type'];
    possessionDesc = json['possession_desc'];
    possessionPrice = json['possession_price'];
    possessionQty = json['possession_qty'];
    possessionLat = json['possession_lat'];
    possessionLong = json['possession_long'];
    possessionState = json['possession_state'];
    possessionLocality = json['possession_locality'];
    possessionDate = json['possession_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['possession_id'] = possessionId;
    data['user_id'] = userId;
    data['possession_name'] = possessionName;
    data['possession_type'] = possessionType;
    data['possession_desc'] = possessionDesc;
    data['possession_price'] = possessionPrice;
    data['possession_qty'] = possessionQty;
    data['possession_lat'] = possessionLat;
    data['possession_long'] = possessionLong;
    data['possession_state'] = possessionState;
    data['possession_locality'] = possessionLocality;
    data['possession_date'] = possessionDate;
    return data;
  }
}