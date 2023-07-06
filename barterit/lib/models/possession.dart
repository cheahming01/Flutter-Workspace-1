class Possession {
  String? possessionId;
  String? userId;
  String? userName;
  String? possessionName;
  String? possessionType;
  String? possessionDesc;
  String? possessionLat;
  String? possessionLong;
  String? possessionState;
  String? possessionLocality;
  DateTime? date_owned;
  bool? cash_checked;
  bool? goods_checked;
  bool? services_checked;
  bool? other_checked;
  bool? publish;

  Possession({
    this.possessionId,
    this.userId,
    this.userName,
    this.possessionName,
    this.possessionType,
    this.possessionDesc,
    this.possessionLat,
    this.possessionLong,
    this.possessionState,
    this.possessionLocality,
    this.date_owned,
    this.cash_checked,
    this.goods_checked,
    this.services_checked,
    this.other_checked,
    this.publish,
  });

  Possession.fromJson(Map<String, dynamic> json) {
    possessionId = json['possession_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    possessionName = json['possession_name'];
    possessionType = json['possession_type'];
    possessionDesc = json['possession_desc'];
    possessionLat = json['possession_lat'];
    possessionLong = json['possession_long'];
    possessionState = json['possession_state'];
    possessionLocality = json['possession_locality'];
    date_owned = json['possession_date'];
    cash_checked = json['cash_checked'] == 1 ? true : false;
    goods_checked = json['goods_checked'] == 1 ? true : false;
    services_checked = json['services_checked'] == 1 ? true : false;
    other_checked = json['other_checked'] == 1 ? true : false;
    publish = json['publish'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['possession_id'] = possessionId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['possession_name'] = possessionName;
    data['possession_type'] = possessionType;
    data['possession_desc'] = possessionDesc;
    data['possession_lat'] = possessionLat;
    data['possession_long'] = possessionLong;
    data['possession_state'] = possessionState;
    data['possession_locality'] = possessionLocality;
    data['date_owned'] = date_owned;
    data['cash_checked'] = cash_checked ?? false ? 1 : 0;
    data['goods_checked'] = goods_checked ?? false ? 1 : 0;
    data['services_checked'] = services_checked ?? false ? 1 : 0;
    data['other_checked'] = other_checked ?? false ? 1 : 0;
    data['publish'] = publish ?? false ? 1 : 0;
    return data;
  }
}
