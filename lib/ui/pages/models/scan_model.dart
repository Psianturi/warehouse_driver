// class ScanModel {
//   int? id;
//   String? trNumber;
//   String? status;
//   User? user;
//
//   ScanModel({this.id, this.trNumber, this.status, this.user});
//
//   ScanModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     // trNumber = json['tr_number'];
//     trNumber = 'SHIP-2023731-00148';
//     status = json['status'];
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['tr_number'] = trNumber;
//     data['status'] = this.status;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     return data;
//   }
// }
//
// class User {
//   int? id;
//   String? deviceId;
//   String? deviceName;
//   String? email;
//   String? password;
//   String? phone;
//   String? name;
//   int? roleId;
//   int? quarryId;
//   int? warehouseId;
//   String? photo;
//
//   User(
//       {this.id,
//         this.deviceId,
//         this.deviceName,
//         this.email,
//         this.password,
//         this.phone,
//         this.name,
//         this.roleId,
//         this.quarryId,
//         this.warehouseId,
//         this.photo});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     deviceId = json['device_id'];
//     deviceName = json['device_name'];
//     email = json['email'];
//     password = json['password'];
//     phone = json['phone'];
//     name = json['name'];
//     roleId = json['role_id'];
//     quarryId = json['quarry_id'];
//     warehouseId = json['warehouse_id'];
//     photo = json['photo'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['device_id'] = this.deviceId;
//     data['device_name'] = this.deviceName;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['phone'] = this.phone;
//     data['name'] = this.name;
//     data['role_id'] = this.roleId;
//     data['quarry_id'] = this.quarryId;
//     data['warehouse_id'] = this.warehouseId;
//     data['photo'] = this.photo;
//     return data;
//   }
// }


class ScanResponseModel {
  List<Data>? data;

  ScanResponseModel({this.data});

  ScanResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  int? id;
  IdTrackDriver? idTrackDriver;
  double? lat;
  double? long;
  double? elevasi;
  double? kecepatan;
  String? lastDate;

  Data({
    this.id,
    this.idTrackDriver,
    this.lat,
    this.long,
    this.elevasi,
    this.kecepatan,
    this.lastDate,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idTrackDriver = IdTrackDriver.fromJson(json['id_track_driver']);
    lat = json['lat'];
    long = json['long'];
    elevasi = json['elevasi'];
    kecepatan = json['kecepatan'];
    lastDate = json['last_date'];
  }
}

class IdTrackDriver {
  int? id;
  String? status;
  Transport? transport;
  User? user;

  IdTrackDriver({this.id, this.status, this.transport, this.user});

  IdTrackDriver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    transport = Transport.fromJson(json['transport']);
    user = User.fromJson(json['user']);
  }
}

class Transport {
  int? id;
  String? number;
  String? type;
  String? driver;
  // ... tambahkan properti lainnya yang diperlukan

  Transport({
    this.id,
    this.number,
    this.type,
    this.driver,
    // ... inisialisasi properti lainnya
  });

  Transport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    type = json['type'];
    driver = json['driver'];
    // ... inisialisasi properti lainnya
  }
}

class User {
  int? id;
  String? email;
  String? phone;
  String? name;
  String? photo; // tambahkan properti photo
  // ... tambahkan properti lainnya yang diperlukan

  User({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.photo,
    // ... inisialisasi properti lainnya
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    photo = json['photo']; // tambahkan inisialisasi untuk properti photo
    // ... inisialisasi properti lainnya
  }
}

