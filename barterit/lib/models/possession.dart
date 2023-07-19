class Possession {
  String? possessionId;
  String? userId;
  String? userName;
  String? possessionName;
  String? possessionType;
  String? possessionDesc;
  String? latitude;
  String? longitude;
  String? state;
  String? locality;
  DateTime? dateOwned;
  bool? cash_checked;
  bool? goods_checked;
  bool? services_checked;
  bool? other_checked;
  bool? publish;
  bool? available;

  Possession({
    this.possessionId,
    this.userId,
    this.userName,
    this.possessionName,
    this.possessionType,
    this.possessionDesc,
    this.latitude,
    this.longitude,
    this.state,
    this.locality,
    this.dateOwned,
    this.cash_checked,
    this.goods_checked,
    this.services_checked,
    this.other_checked,
    this.publish,
    this.available,
  });

  Possession.fromJson(Map<String, dynamic> json) {
    possessionId = json['possession_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    possessionName = json['possession_name'];
    possessionType = json['possession_type'];
    possessionDesc = json['possession_desc'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    state = json['state'];
    locality = json['locality'];
    dateOwned = DateTime.parse(json['date_owned']);
    cash_checked = json['cash_checked'];
    goods_checked = json['goods_checked'];
    services_checked = json['services_checked'];
    other_checked = json['other_checked'];
    publish = json['publish'];
    available = json['available'];
  }

  get possessionState => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['possession_id'] = possessionId;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['possession_name'] = possessionName;
    data['possession_type'] = possessionType;
    data['possession_desc'] = possessionDesc;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['state'] = state;
    data['locality'] = locality;
    data['date_owned'] = dateOwned?.toIso8601String();
    data['cash_checked'] = cash_checked;
    data['goods_checked'] = services_checked;
    data['services_checked'] = services_checked;
    data['other_checked'] = other_checked;
    data['publish'] = publish;
    data['available'] = available;
    return data;
  }
}
