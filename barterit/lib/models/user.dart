class User {
  String? id;
  String? name;
  String? phone;
  String? password;
  String? otp;
  String? datereg;
  String? cash;

  User(
      {this.id,
      this.name,
      this.phone,
      this.password,
      this.otp,
      this.datereg,
      this.cash});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    otp = json['otp'];
    datereg = json['datereg'];
    cash = json['cash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    data['otp'] = otp;
    data['datereg'] = datereg;
    data['cash'] = cash;
    return data;
  }
}
