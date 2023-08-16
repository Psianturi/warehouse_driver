class UserModel {
  Meta? meta;
  List<Null>? pagination;
  List<Data>? data;

  UserModel({this.meta, this.pagination, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? code;
  String? status;
  String? message;
  bool? isPaginated;

  Meta({this.code, this.status, this.message, this.isPaginated});

  Meta.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];
    isPaginated = json['is_paginated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['status'] = this.status;
    data['message'] = this.message;
    data['is_paginated'] = this.isPaginated;
    return data;
  }
}

class Data {
  int? id;
  IdTrackDriver? idTrackDriver;
  double? lat;
  double? long;
  double? elevasi;
  double? kecepatan;
  int? battery;
  String? lastDate;

  Data(
      {this.id,
        this.idTrackDriver,
        this.lat,
        this.long,
        this.elevasi,
        this.kecepatan,
        this.battery,
        this.lastDate});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idTrackDriver = json['id_track_driver'] != null
        ? new IdTrackDriver.fromJson(json['id_track_driver'])
        : null;
    lat = json['lat'];
    long = json['long'];
    elevasi = json['elevasi'];
    kecepatan = json['kecepatan'];
    battery = json['battery'];
    lastDate = json['last_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.idTrackDriver != null) {
      data['id_track_driver'] = this.idTrackDriver!.toJson();
    }
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['elevasi'] = this.elevasi;
    data['kecepatan'] = this.kecepatan;
    data['battery'] = this.battery;
    data['last_date'] = this.lastDate;
    return data;
  }
}

class IdTrackDriver {
  int? id;
  String? trNumber;
  String? status;
  User? user;
  String? numberVehicle;

  IdTrackDriver(
      {this.id, this.trNumber, this.status, this.user, this.numberVehicle});

  IdTrackDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trNumber = json['tr_number'];
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    numberVehicle = json['number_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tr_number'] = this.trNumber;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['number_vehicle'] = this.numberVehicle;
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
