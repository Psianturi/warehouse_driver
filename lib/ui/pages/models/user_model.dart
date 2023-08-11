
class UserModel {
  List<Data>? data;

  UserModel({this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String? photo;


  User({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.photo, //
    // ... inisialisasi properti lainnya
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    photo = json['photo'];
    // ... inisialisasi properti lainnya
  }
}
