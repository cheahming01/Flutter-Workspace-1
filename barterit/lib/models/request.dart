class Request {
  String? reqId;
  String? request_user_id;
  String? ownerPossId;
  String? cashInput;
  String? userPossId;
  DateTime? timeReq;
  String? notification;
  String? status;
  String? ownerPossName;
  String? userPossName;
  bool? ownerPossAvailable;
  bool? userPossAvailable;
  String? ownerid;
  String? ownerUsername;
  String? userUsername;

  Request({
    this.reqId,
    this.request_user_id,
    this.ownerPossId,
    this.cashInput,
    this.userPossId,
    this.timeReq,
    this.notification,
    this.status,
    this.ownerPossName,
    this.userPossName,
    this.ownerPossAvailable,
    this.userPossAvailable,
    this.ownerid,
    this.ownerUsername,
    this.userUsername,
  });

  Request.fromJson(Map<String, dynamic> json) {
    reqId = json['req_id'];
    request_user_id = json['request_user_id'];
    ownerPossId = json['owner_poss_id'];
    cashInput = json['cash_input'];
    userPossId = json['user_poss_id'];
    timeReq = DateTime.parse(json['time_req']);
    notification = json['notification'];
    status = json['status'];
    ownerPossName = json['owner_poss_name'];
    userPossName = json['user_poss_name'];
    ownerPossAvailable = json['owner_poss_available'];
    userPossAvailable = json['user_poss_available'];
    ownerid = json['ownerid'];
    ownerUsername = json['owner_username'];
    userUsername = json['user_username'];
  }

  get possessionState => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['req_id'] = reqId;
    data['request_user_id'] = request_user_id;
    data['owner_poss_id'] = ownerPossId;
    data['cash_input'] = cashInput;
    data['user_poss_id'] = userPossId;
    data['time_req'] = timeReq;
    data['notification'] = notification;
    data['status'] = status;
    data['owner_poss_name'] = ownerPossName;
    data['user_poss_name'] = userPossName;
    data['owner_poss_available'] = ownerPossAvailable;
    data['user_poss_available'] = userPossAvailable;
    data['ownerid'] = ownerid;
    data['owner_username'] = ownerUsername;
    data['user_username'] = userUsername;
    return data;
  }
}
