
class UserModel {
  User? user;

  UserModel({this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? deviceId;
  String? deviceName;
  String? email;
  String? phone;
  String? name;
  int? roleId;
  int? quarryId;
  int? warehouseId;
  String? photo;

  User(
      {this.id,
        this.deviceId,
        this.deviceName,
        this.email,
        this.phone,
        this.name,
        this.roleId,
        this.quarryId,
        this.warehouseId,
        this.photo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['device_id'];
    deviceName = json['device_name'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    roleId = json['role_id'];
    quarryId = json['quarry_id'];
    warehouseId = json['warehouse_id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['device_id'] = this.deviceId;
    data['device_name'] = this.deviceName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['role_id'] = this.roleId;
    data['quarry_id'] = this.quarryId;
    data['warehouse_id'] = this.warehouseId;
    data['photo'] = this.photo;
    return data;
  }
}
